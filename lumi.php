<?php
 
 class lumi{	  
 const url = 'http://www.skiplan.com/php/getXmlInter.php?country=russia&region=alpes&resort=ROSA%20KHUTOR';
 
 private static function get_feed(){
             $ch = curl_init();
            curl_setopt( $ch, CURLOPT_URL, self::url);
            curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1 );
			curl_setopt($ch, CURLOPT_HEADER, false); 
            curl_setopt( $ch, CURLOPT_CONNECTTIMEOUT, 5 );
			curl_setopt($ch, CURLOPT_TIMEOUT, 60);
            $data = curl_exec( $ch );
            curl_close( $ch );
			$xml = simplexml_load_string($data);
            return $xml;
			}     


			
public static function get_data(){

//Get serilaze data to Plato data from lumiplan xml feed

  $v1 = self::get_feed();
  $temp_p = $v1->WEATHER->PARAMETERS->AREA[0]->C_TEMPERATURE;
  $wind_p = $v1->WEATHER->PARAMETERS->AREA[0]->DIRECTION.' '.$v1->WEATHER->PARAMETERS->AREA[0]->K_WIND;
  $snow_p = $v1->WEATHER->PARAMETERS->AREA[0]->I_ACCUMULATION.' /'.$v1->WEATHER->PARAMETERS->AREA[0]->C_ACCUMULATION;
  $img = $v1->WEATHER->PARAMETERS->AREA[0]->SKY_ID;
  
  ////Get serilaze data to Rosa 1600 data from lumiplan xml feed
  
  $temp_r = $v1->WEATHER->PARAMETERS->AREA[1]->C_TEMPERATURE;
  $wind_r = $v1->WEATHER->PARAMETERS->AREA[1]->DIRECTION.' '.$v1->WEATHER->PARAMETERS->AREA[1]->K_WIND;
  $snow_r = $v1->WEATHER->PARAMETERS->AREA[1]->I_ACCUMULATION.' /'.$v1->WEATHER->PARAMETERS->AREA[1]->C_ACCUMULATION;
  $img1 = $v1->WEATHER->PARAMETERS->AREA[1]->SKY_ID;
     
  switch($img)
			{
				case 1:				
				$img_fl1 = 'Sun';
				break;
				
				case 2:				
				$img_fl1 = 'Clody_Sun';
				break;
				
				case 3:				
				$img_fl1 = 'Clouds';
				break;
				
				case 4:				
				$img_fl1 = 'Cloud_Rain';
				break;
				
				case 5:				
				$img_fl1 = 'Cloud_Snow';
				break;
				
				case 6:				
				$img_fl1 = 'Cloud_Storm';
				break;
				
				default:				
				$img_fl1 = '';
			}
			
	switch($img1)
			{
				case 1:				
				$img_fl2 = 'Sun';
				break;
				
				case 2:
				$img_fl2 = 'Clody_Sun';
				break;
				
				case 3:				
				$img_fl2 = 'Clouds';
				break;	
				
				case 4:				
				$img_fl2 = 'Cloud_Rain';
				break;
				
				case 5:				
				$img_fl2 = 'Cloud_Snow';
				break;
				
				case 6:				
				$img_fl2 = 'Cloud_Storm';
				break;
				
				default:				
				$img_fl2 = '';
			}
			
    $feed = array (
	'temp_p' => $temp_p,
	'wind_p' => $wind_p,
	'snow_p' => $snow_p,
	'sky_p'=> $img_fl1,
	'temp_r' => $temp_r,
	'wind_r' => $wind_r,
	'snow_r' => $snow_r,
	'sky_r'=> $img_fl2
	);
	 	
   	      return $feed;     

      }
   
 
   }
?> 