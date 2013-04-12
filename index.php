<?php 
require_once("lumi.php");

$data = lumi::get_data();  
 //echo $data['temp_p']; echo $data['temp_r'];

$temp_p = $data['temp_p'];
$wind_p = $data['wind_p'];
$sky_p = $data['sky_p'];
$snow_p = $data['snow_p'];

$temp_r = $data['temp_r'];
$wind_r = $data['wind_r'];
$sky_r = $data['sky_r'];
$snow_r = $data['snow_r'];


if (isset($_GET["cam"])) {
$v22 = $_GET["cam"];
}

switch($v22) 
			{
				case 'Plato':
				$v22 = 'Плато';
				$sbody = "
				<link url='http://172.17.6.97:8080/stream.flv' tit='Плато' temp='$temp_p' wind='$wind_p' tr='$temp_r' wr='$wind_r' snow='$snow_p' img='$sky_p' />           
			    <link url='http://172.17.6.97:8080/stream.flv' tit='Ресторан Зима' temp='$temp_p' wind='$wind_p' snow='$snow_p' img='$sky_p' />			 					
				<link url='http://172.17.6.97:8080/stream.flv' tit='Роза 1600' temp='$temp_r' wind='$wind_r' snow='$snow_r' img='$sky_r' />				
				 ";
				
				break;
				case 'Zima':
				$v22 = 'Ресторан Зима';
				$sbody = "
				<link url='http://172.17.6.97:8080/stream.flv' tit='Ресторан Зима' temp='$temp_p' wind='$wind_p' tr='$temp_r' wr='$wind_r' snow='$snow_p' img='$sky_p' />		  	
			    <link url='http://172.17.6.97:8080/stream.flv' tit='Роза 1600' temp='$temp_r' wind='$wind_r' snow='$snow_r' img='$sky_r' />
				<link url='http://172.17.6.97:8080/stream.flv' tit='Плато' temp='$temp_p' wind='$wind_p' snow='$snow_p' img='$sky_p' />                			
			    ";
				break;
				
				case 'Rosa_1600':
				$v22 = 'Роза 1600';
				$sbody = "
				<link url='http://172.17.6.97:8080/stream.flv' tit='Роза 1600' temp='$temp_p' wind='$wind_p' tr='$temp_r' wr='$wind_r' snow='$snow_r' img='$sky_r' />
				<link url='http://172.17.6.97:8080/stream.flv' tit='Плато' temp='$temp_p' wind='$wind_p' snow='$snow_p' img='$sky_p' />              
			    <link url='http://172.17.6.97:8080/stream.flv' tit='Ресторан Зима' temp='$temp_p' wind='$wind_p' snow='$snow_p' img='$sky_p' />                			   	
			    ";
				break;
				
				case 'Post_2100':
				$v22 = 'Лавинный пост';
				$sbody = "
				<link url='http://172.17.6.97:8080/stream.flv' tit='Лавинный пост' temp='$temp_p' wind='$wind_p' tr='$temp_r' wr='$wind_r' snow='$snow_r' img='$sky_r' />
				<link url='http://172.17.6.97:8080/stream.flv' tit='Плато' temp='$temp_p' wind='$wind_p' snow='$snow_p' img='$sky_p' />              
			    <link url='http://172.17.6.97:8080/stream.flv' tit='Ресторан Зима' temp='$temp_p' wind='$wind_p' snow='$snow_p' img='$sky_p' />                			   	
			    ";
				break;
				
				default:
			    $v22 = null;
				$sbody = "";           
				break;
			}
$body="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<videos>";
$body .= $sbody;
$body .="</videos>";
$path="tfeed.xml";
$filenum=fopen($path,"w");
fwrite($filenum,$body);
fclose($filenum);
?>