component {

	moduleRoot = createObject( "java", "java.io.File" )
		.init( getDirectoryFromPath( getCurrentTemplatePath() ) & "../../../" )
		.getCanonicalPath();

	this.name                        = "cbjavaloader-full-null-regression-#hash( moduleRoot )#";
	this.enableNullSupport           = true;
	this.mappings[ "/cbjavaloader" ] = moduleRoot;

}
