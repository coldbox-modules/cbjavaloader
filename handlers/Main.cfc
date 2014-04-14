/**
* My Event Handler Hint
*/
component{

	property name="javaloader" inject="loader@javaloader";

	// Index
	any function index( event,rc, prc ){
		prc.hello = javaloader.create( "HelloWorld" ).init().hello();
	}

}