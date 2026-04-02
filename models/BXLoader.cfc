/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * BoxLang 1.8.0+ native class loader implementation.
 * Extends Loader and overrides all methods to use BoxLang's native request class loader
 * instead of the bundled JavaLoader library.
 */
component extends="Loader" accessors="true" singleton {

	/**
	 * Constructor — no server-scope key needed for BoxLang native mode.
	 */
	function init(){
		return this
	}

	/**
	 * Setup class loading using the native BoxLang request class loader.
	 *
	 * @moduleSettings The module settings struct (only loadPaths is used in BoxLang native mode)
	 */
	function setup( required struct moduleSettings ){
		var loadPaths = arguments.moduleSettings.loadPaths ?: []
		if ( !isArray( loadPaths ) ) {
			loadPaths = listToArray( loadPaths )
		}
		if ( arrayLen( loadPaths ) ) {
			getRequestClassLoader().addPaths( loadPaths )
		}
	}

	/**
	 * Not applicable in BoxLang native mode — the request class loader is managed by the runtime.
	 */
	function getJavaLoader(){
		throw(
			message = "getJavaLoader() is not available in BoxLang native mode",
			type    = "BXLoader.NotSupported"
		)
	}

	/**
	 * Retrieves a reference to the java class via the BoxLang native request class loader.
	 * Call init() on the returned reference to create an instance.
	 *
	 * @className The fully qualified class name to create, e.g. "com.mypackage.MyClass"
	 *
	 * @return The Java class reference
	 */
	function create( required string className ){
		return createObject( type:"java", className: arguments.className, classLoader: getRequestClassLoader() )
	}

	/**
	 * Appends a directory of *.jar or *.class files to the native request class loader.
	 *
	 * @dirPath The directory absolute path to load
	 * @filter  The directory filter
	 */
	function appendPaths( required string dirPath, string filter = "*.jar" ){
		var newPaths = arrayOfJars( argumentCollection = arguments )
		if ( arrayLen( newPaths ) ) {
			getRequestClassLoader().addPaths( newPaths )
		}
	}

	/**
	 * Get all the loaded URLs from the native request class loader.
	 */
	array function getLoadedURLs(){
		return getRequestClassLoader()
			.getURLs()
			.map( target => target.toString() )
	}

	/**
	 * Returns the native BoxLang request class loader.
	 */
	any function getURLClassLoader(){
		return getRequestClassLoader()
	}

	/**
	 * Returns the JavaLoader facade version string.
	 * BoxLang native mode does not use JavaLoader, so a static version is returned.
	 */
	string function getVersion(){
		return "1.2"
	}

}
