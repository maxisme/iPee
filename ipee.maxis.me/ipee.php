<?php
if ( isset( $_SERVER[ 'HTTP_X_FORWARDED_FOR' ] ) && $_SERVER[ 'HTTP_X_FORWARDED_FOR' ] ) {
	$clientIpAddress = $_SERVER[ 'HTTP_X_FORWARDED_FOR' ];
} else {
	$clientIpAddress = $_SERVER[ 'REMOTE_ADDR' ];
}



if ( !isset( $_GET[ 'more' ] ) ) {
	die( $clientIpAddress );
}



$array = @unserialize( file_get_contents( "http://ip-api.com/php/$clientIpAddress" ) );

$rewriteKeys = array( 'city' => 'City', 'zip' => 'Post Code', 'isp' => 'ISP', 'country' => 'Country' );

$newArr = array();
foreach ( $array as $key => $value ) {
	if ( !empty( $rewriteKeys[ $key ] ) )
		$newArr[ $rewriteKeys[ $key ] ] = $value;
}

$array1 = $newArr;

echo json_encode( $array1 );

?>