#include <meta>
using namespace std::meta;

template < typename E, bool B = is_enumerable_type( ^^E ) >
constexpr std::string_view enum_to_string( E e )
{
	if constexpr ( B )
	{
		constexpr info Enums = reflect_constant_array( enumerators_of( ^^E ) );
		template for ( constexpr info I : [:Enums:] ) if ( e == [:I:] ) return identifier_of( I );
	}
	return "<unnamed>";
}

template < typename E, bool B = is_enumerable_type( ^^E ) >
constexpr std::optional< E > string_to_enum( std::string_view s )
{
	if constexpr ( B )
	{
		constexpr info Enums = reflect_constant_array( enumerators_of( ^^E ) );
		template for ( constexpr info I : [:Enums:] ) if ( s == identifier_of( I ) ) return [:I:];
	}
	return std::nullopt;
}

consteval void test()
{
	enum class Color : int;
	static_assert( enum_to_string( Color { 0 } ) == "<unnamed>" );
	static_assert( enum_to_string( Color { 3 } ) == "<unnamed>" );

	enum class Color : int
	{
		Red,
		Green,
		Blue,
		Yellow
	};
	static_assert( enum_to_string( Color::Red ) == "Red" );
	static_assert( enum_to_string( Color::Green ) == "Green" );
	static_assert( enum_to_string( Color::Blue ) == "Blue" );
	static_assert( enum_to_string( Color::Yellow ) == "Yellow" );
	static_assert( enum_to_string( Color { 0 } ) == "Red" );
	static_assert( enum_to_string( Color { 3 } ) == "Yellow" );
	static_assert( enum_to_string( Color { 4 } ) == "<unnamed>" );

	static_assert( string_to_enum< Color >( "Red" ) == Color::Red );
	static_assert( string_to_enum< Color >( "Green" ) == Color::Green );
	static_assert( string_to_enum< Color >( "Blue" ) == Color::Blue );
	static_assert( string_to_enum< Color >( "Yellow" ) == Color::Yellow );
	static_assert( string_to_enum< Color >( "White" ) == std::nullopt );
}

int main()
{
	test();
}