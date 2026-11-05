/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

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
			beforeEach( function( currentSpec ){
				setup();
			} );

			it( "should register loader proxy", function(){
				var loader = getLoader();
				expect( loader ).toBeComponent();
			} );

			it( "should class load jar files", function(){
				var event = execute( "main.index" );
				var prc   = event.getCollection( private = true );
				expect( prc.hello ).toBe( "Hello World" );
			} );

			it( "should get loaded URLs", function(){
				var loader = getLoader()
				expect( loader.getLoadedURls() ).toBeArray()
				expect( loader.getLoadedURLs().len() ).toBeGTE( 2 )
			} );

			it( "should retrieve via custom DSL", function(){
				var hello = getWireBox().getInstance( dsl = "javaloader:HelloWorld" );
				expect( isObject( hello ) ).toBeTrue();
			} );

			it(
				title = "should cache its class loader under the application name",
				skip  = structKeyExists( server, "boxlang" ),
				body  = function(){
					var javaLoader = getLoader().getJavaLoader();
					var key        = "A0608BEC-0AEB-B46A-0E1E1EC5F3CE7C9C." & javaLoader.getVersion() & ".networkclassloader." & application.applicationName;

					expect( structKeyExists( server, key ) ).toBeTrue();
				}
			);

			it(
				title = "should reuse its class loader when the module reinitializes with the same settings",
				skip  = structKeyExists( server, "boxlang" ),
				body  = function(){
					var loader = getLoader();
					var system = createObject( "java", "java.lang.System" );
					var before = system.identityHashCode( loader.getURLClassLoader() );

					loader.setup( { loadPaths : duplicate( loader.getJavaLoader().getClassLoadPaths() ) } );

					expect( system.identityHashCode( loader.getURLClassLoader() ) ).toBe( before );
				}
			);
		} );
	}

	private function getLoader(){
		return getWireBox().getInstance( "loader@cbjavaloader" );
	}

}
