/**
* My Event Handler Hint
*/
component{

	property name="javaloader" inject="loader@cbjavaloader";

	// Index
	any function index( event,rc, prc ){

		prc.test = wirebox.getInstance( dsl="javaloader:HelloWorld" );

		prc.hello = javaloader.create( "HelloWorld" ).init().hello();
	}

	// Run on first init
	any function onAppInit( event, rc, prc ){
		javaloader.appendPaths( getSetting( "ApplicationPath" ) & "jars" );
	}

}