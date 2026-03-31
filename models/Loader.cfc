/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Loads External Java Classes, while providing access to ColdFusion classes by interfacing with JavaLoader
 * it Stores a reference in server scope to avoid leakage.
 */
component accessors="true" singleton {

	property name="wirebox" inject="wirebox";

	/**
	 * ID key saved in server scope to avoid leakage
	 */
	property name="staticIDKey";

	/**
	 * Constructor
	 */
	function init(){
		// setup a static ID key according to coldbox app
		variables.staticIDKey = "cbox-javaloader-#hash( getCurrentTemplatePath() )#";
		return this;
	}

	/**
	 * Setup class loading
	 */
	function setup( required struct moduleSettings ){
		// BoxLang 1.8.0+: use native class loading, skip JavaLoader entirely
		if ( isBoxLangNative() ) {
			var loadPaths = arguments.moduleSettings.loadPaths ?: [];
			if ( !isArray( loadPaths ) ) {
				loadPaths = listToArray( loadPaths );
			}
			lock name="#variables.staticIDKey#" throwontimeout="true" timeout="30" type="exclusive" {
				server[ getStaticIDKey() ] = loadPaths;
			}
			if ( arrayLen( loadPaths ) ) {
				getRequestClassLoader().addPaths( loadPaths );
			}
			return;
		}

		// verify we have it loaded
		if ( not isJavaLoaderInScope() ) {
			lock name="#variables.staticIDKey#" throwontimeout="true" timeout="30" type="exclusive" {
				if ( not isJavaLoaderInScope() ) {
					setJavaLoaderInScope(
						variables.wirebox.getInstance( name = "jl@cbjavaloader", initArguments = moduleSettings )
					);
				}
			}
		} else {
			// reconfigure it, maybe settings changed
			lock name="#variables.staticIDKey#" throwontimeout="true" timeout="30" type="exclusive" {
				getJavaLoaderFromScope().init( argumentCollection = moduleSettings );
			}
		}
	}

	/**
	 * Get the original java loader object from scope
	 */
	function getJavaLoader(){
		return getJavaLoaderFromScope();
	}

	/**
	 * Retrieves a reference to the java class. To create a instance, you must run init() on this object
	 */
	function create( required string className ){
		if ( isBoxLangNative() ) {
			return createObject( "java", arguments.className, getRequestClassLoader() );
		}
		return getJavaLoaderFromScope().create( argumentCollection = arguments );
	}

	/**
	 * Appends a directory path of *.jar's,*.classes to the current loaded class loader.
	 *
	 * @dirPath.hint The directory absolute path to load
	 * @filter.hint  The directory filter
	 */
	function appendPaths( required string dirPath, string filter = "*.jar" ){
		// BoxLang 1.8.0+: use native class loading
		if ( isBoxLangNative() ) {
			var newPaths = arrayOfJars( argumentCollection = arguments );
			lock name="#variables.staticIDKey#" throwontimeout="true" timeout="30" type="exclusive" {
				var stored = structKeyExists( server, getStaticIDKey() ) ? server[ getStaticIDKey() ] : [];
				stored.addAll( newPaths );
				server[ getStaticIDKey() ] = stored;
			}
			if ( arrayLen( newPaths ) ) {
				getRequestClassLoader().addPaths( newPaths );
			}
			return;
		}

		// Convert paths to array of file locations
		var qFiles         = arrayOfJars( argumentCollection = arguments );
		var iterator       = qFiles.iterator();
		var thisFile       = "";
		var URLClassLoader = "";

		// Try to check if javaloader in scope? else, set it up.
		if ( NOT isJavaLoaderInScope() ) {
			setup( qFiles );
			return;
		}

		// Get URL Class Loader
		URLClassLoader = getURLClassLoader();

		// Try to load new locations
		while ( iterator.hasNext() ) {
			thisFile = createObject( "java", "java.io.File" ).init( iterator.next() );
			if ( NOT thisFile.exists() ) {
				throw(
					message = "The path you have specified could not be found",
					detail  = thisFile.getAbsolutePath() & "does not exist",
					type    = "PathNotFoundException"
				);
			}
			// Load up the URL
			URLClassLoader.addUrl( thisFile.toURL() );
		}
	}

	/**
	 * Get all the loaded URLs
	 */
	array function getLoadedURLs(){
		// BoxLang 1.8.0+: return the stored paths array
		if ( isBoxLangNative() ) {
			return structKeyExists( server, getStaticIDKey() ) ? server[ getStaticIDKey() ] : [];
		}

		var loadedURLs  = getURLClassLoader().getURLs();
		var returnArray = arrayNew( 1 );
		var x           = 1;

		for ( x = 1; x lte arrayLen( loadedURLs ); x = x + 1 ) {
			arrayAppend( returnArray, loadedURLs[ x ].toString() );
		}

		return returnArray;
	}

	/**
	 * Returns the java.net.URLClassLoader in case you need access to it
	 */
	any function getURLClassLoader(){
		// BoxLang 1.8.0+: return the native request class loader
		if ( isBoxLangNative() ) {
			return getRequestClassLoader();
		}
		return getJavaLoaderFromScope().getURLClassLoader();
	}

	/**
	 * Get the Javaloader Version
	 */
	string function getVersion(){
		if ( isBoxLangNative() ) {
			return "boxlang-native";
		}
		return getJavaLoaderFromScope().getVersion();
	}

	/**
	 * Get an array of jars from a directory location
	 */
	array function arrayOfJars( required string dirPath, string filter = "*.jar" ){
		if ( not directoryExists( arguments.dirPath ) ) {
			throw(
				message = "Invalid library path",
				detail  = "The path is #dirPath#",
				type    = "JavaLoader.DirectoryNotFoundException"
			);
		}

		return directoryList(
			arguments.dirPath,
			true,
			"array",
			arguments.filter,
			"name desc"
		);
	}

	/************************************** private *********************************************/

	private function setJavaLoaderInScope( required any javaLoader ){
		server[ getStaticIDKey() ] = arguments.javaLoader;
	}

	private function getJavaLoaderFromScope(){
		return server[ getstaticIDKey() ];
	}


	private boolean function isJavaLoaderInScope(){
		return structKeyExists( server, getstaticIDKey() );
	}

	/**
	 * Detects whether we are running on BoxLang, which always supports native dynamic class loading.
	 */
	private boolean function isBoxLangNative(){
		return structKeyExists( server, "boxlang" );
	}

}
