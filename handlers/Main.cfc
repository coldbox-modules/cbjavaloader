/**
* My Event Handler Hint
*/
component{

	property name="javaloader" inject="loader@javaloader";

	// Index
	any function index( event,rc, prc ){
		prc.hello = javaloader.create( "HelloWorld" ).init().hello();
	}

	// Run on first init
	any function onAppInit( event, rc, prc ){
		javaloader.appendPaths( getSetting( "ApplicationPath" ) & "jars" );
	}

}