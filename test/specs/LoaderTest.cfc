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
				var loader = getLoader();
				expect(	loader.create( "HelloWorld" ).init().hello() )
					.toBe( "Hello World" );
			});
			
			it( "should get loaded URLs", function(){
				var loader = getLoader();
				expect(	loader.getLoadedURls() ).toBeArray();
				expect( loader.getLoadedURLs() ).toHaveLength( 1 );
			});
		});
	}

	private function getLoader(){
		return getWireBox().getInstance( "loader@javaloader" );
	}
	
}