<?php
if(!isset($_GET['uid']) || !isset($_GET['password']) || $_GET['uid'] == "" || $_GET['password'] == "")
{
	die("license.php?uid=UID&password=PASSWORD<br>\nlicense.php?uid=UID&password=PASSWORD&ip=IP<br>\n");
}
if(isset($_GET['ip']) && $_GET['ip'] == "")
{
	die('Error IP!');
}

$data = array('ajax_login' => '1', 'uid' => $_GET['uid'], 'password' => $_GET['password']);
$ip = isset($_GET['ip']) ? $_GET['ip'] : $_SERVER['REMOTE_ADDR'];
$info = array(
'action'  => 'create_license',
'payment' => '',
'pid'     => '2715',
'name'    => 'HDPro',
'os'      => 'ES 6.0 64',
'ip'      => $ip,
'email'   => 'abc@gmail.com',
'domain'  => 'domain.com',
);

cURL('https://directadmin.com', NULL, NULL, 'GetCookie');
cURL('https://directadmin.com/clients/login.php', $data, NULL, 'LoadCookie');
$text = cURL('https://directadmin.com/clients/index.php', NULL);
if(preg_match('/href="license.php\?lid=(.*?)"/', $text, $matches))
{
	$lid = $matches[1];
	preg_match('/<span class=" mr8 fs14 fw600">IP<\/span>(.*?)				<\/div>/', $text, $matches);
	$ip = $matches[1];
}
else
{
	$text = cURL('https://directadmin.com/clients/trial.php', $info, 'https://directadmin.com/clients/trial.php');
	if(preg_match('/This IP already exists/', $text, $matches))
	{
		die('IP Already Exists!');
	}
	if(preg_match('/lid=(.*?)\n/', $text, $matches))
	{
		$lid = $matches[1];
	}
	else
	{
		die('LID Get Error!');
	}
}
$uid = $_GET['uid'];

$file = fopen('license.txt', 'a+');
fwrite($file, "=======================\n");
fwrite($file, "UID: $uid\nLID: $uid\nIP: $ip\n");
fwrite($file, "=======================\n");
fclose($file);

$text = "UID: $uid<br>
LID: $lid<br>
IP: $ip<br>
update.tar.gz: <a href=\"https://update.directadmin.com/cgi-bin/daupdate?uid=$uid&lid=$lid\" target=\"_blank\">Download</a><br>
license.key: <a href=\"https://directadmin.com/cgi-bin/licenseupdate?uid=$uid&lid=$lid\" target=\"_blank\">Download</a>";

echo $text;

function cURL($url = NULL, $data = NULL, $ref = NULL, $type = NULL)
{
	if(isset($url))
	{
		$curl = curl_init();
		curl_setopt($curl,CURLOPT_URL,$url);
		if(isset($data) && is_array($data))
		{
			curl_setopt($curl, CURLOPT_POST, TRUE);
			curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query($data));
		}
		$header = array(
			'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36',
			'Content-Type: application/x-www-form-urlencoded',
		);
		if(!isset($ref))
		{
			$header[] = 'Referer: https://directadmin.com/';
		}
		else if($ref != '')
		{
			$header[] = 'Referer: ' . $ref;
		}
		curl_setopt($curl, CURLOPT_HEADER, TRUE);
		curl_setopt($curl, CURLOPT_HTTPHEADER, $header);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, TRUE);
		curl_setopt($curl, CURLOPT_CONNECTTIMEOUT ,3600);
		curl_setopt($curl, CURLOPT_TIMEOUT, 3600);
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE);
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, FALSE);
		curl_setopt($curl, CURLOPT_COOKIESESSION, TRUE);
		if($type=='GetCookie')
		{
			curl_setopt($curl, CURLOPT_COOKIEJAR, 'cookie.txt');
		}
		else if($type=='LoadCookie')
		{
			curl_setopt($curl, CURLOPT_COOKIEJAR, 'cookie.txt');
			curl_setopt($curl, CURLOPT_COOKIEFILE, 'cookie.txt');
		}
		else
		{
			curl_setopt($curl, CURLOPT_COOKIEFILE, 'cookie.txt');
		}
		$response = curl_exec($curl);
		curl_close($curl);
		return $response;
	}
}
?>