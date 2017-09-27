/**
* My BDD Test
*/
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
		structDelete( server, getLoader().getStaticIDKey() );
	}

/*********************************** BDD SUITES ***********************************/

	function run(){

		// all your suites go here.
		describe( "JavaLoader Module", function(){

			beforeEach(function( currentSpec ){
				setup();
			});

			it( "should register loader proxy", function(){
				var loader = getLoader();
				expect(	loader ).toBeComponent();
			});

			it( "should class load jar files", function(){
				var event = execute( "main.index" );
				var prc = event.getCollection( private=true );
				expect(	prc.hello )
					.toBe( "Hello World" );
			});

			it( "should get loaded URLs", function(){
				var loader = getLoader();
				expect(	loader.getLoadedURls() ).toBeArray();
				expect( loader.getLoadedURLs() ).toHaveLength( 2 );
			});

			it( "should retrieve via custom DSL", function(){
				var hello = getWireBox().getInstance( dsl="javaloader:HelloWorld" );
				expect( isObject( hello ) ).toBeTrue();
			});
		});

	}

	private function getLoader(){
		return getWireBox().getInstance( "loader@cbjavaloader" );
	}

}