<cfscript>
loader = new cbjavaloader.models.javaloader.JavaLoader().init();

if ( !isArray( loader.getClassLoadPaths() ) || !isInstanceOf( loader.getURLClassLoader(), "java.lang.ClassLoader" ) ) {
	throw( type = "RegressionFailure", message = "The public loader did not initialize." );
}

writeOutput( "PASS" );
</cfscript>
