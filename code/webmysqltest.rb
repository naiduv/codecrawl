#!/usr/bin/ruby -w
#
# Prochazi strukturu databaze a vytvari test
#
# Pouziti: webmysqltest.rb db_user db_heslo jmeno_databaze cesta_ke_generovanemu_testu
#

require 'mysql'

php_pred='<?php
/*
 * Test overuje, zda struktura lokalni databaze odpovida strukture, 
 * ktera byla zamyslena v dobe vygenerovani tohoto testu, cili v dobe exportu.
 * 
 * pouziti: php __FILE__ db_user db_pass lokalni_databaze
 */'
php_po='
if (empty($argv) || $argc != 4) {
	die("test ma nasledujici parametry: jmeno heslo databaze\n");
}

$db = new mysqli("localhost", $argv[1], $argv[2], $argv[3]);
$res = $db->query("SHOW TABLES");
while (list($tbl) = $res->fetch_row()) {
	$restbl = $db->query("DESCRIBE ".$tbl);
	$arr = array();
	while ($col = $restbl->fetch_assoc()) {
		$nazev = $col["Field"];
		unset($col["Field"]);
		$arr[$nazev] = $col;
	}
	$lokalni[$tbl] = $arr;
	$restbl->free();
}
$res->free();

echo "VYSLEDEK TESTU: ".($globalni == $lokalni ? "OK" : "FAILED!")."\n";

function compare_func($a, $b)
{
	if (is_array($b) && is_array($b)) {
		$p = array_udiff_assoc($a, $b, "compare_func");
		if (!empty($p)) {
			print_r($p);
			return 1;
		}
		$r = array_udiff_assoc($b, $a, "compare_func");
		if (!empty($r)) {
			print_r($r);
			return -1;
		}
		return 0;
	}

	if ($a == $b) {
		return 0;
	}
	return ($a > $b)? 1:-1;
}

function vypis_pole($arr) {
	foreach($arr as $k=>$v)
		echo "\t\t[" . $k . "] => " . $v . "\n";
}

if ($globalni != $lokalni) {
	echo "VERZE PROGRAMU, KTEROU POUZIVATE, VYZADUJE NASLEDUJICI CASTI DB ODLISNE:\n";
	$glo_vs_lok = array_udiff_assoc($globalni, $lokalni, "compare_func");
	if (!empty($glo_vs_lok)) {
		echo "ODLISNOSTI TABULEK POUZITE VERZE VUCI LOKALNIM:\n";
		vypis_pole(array_keys($glo_vs_lok));
	}
	echo "LOKALNI DATABAZE OBSAHUJE NASLEDUJICI CASTI, KTERE NEJSOU VYZADOVANY:\n";
	$lok_vs_glo = array_udiff_assoc($lokalni, $globalni, "compare_func");
	if (!empty($lok_vs_glo)) {
		echo "ODLISNOSTI TABULEK LOKALNI VERZE VUCI VYZADOVANYM:\n";
		vypis_pole(array_keys($lok_vs_glo));
	}
	exit(1);
} else {
	exit(0);
}
?>'

fields = Array[ "Field", "Type", "Null", "Key", "Default", "Extra" ]

if $*.length != 4
	puts "Mysql structure test creator"
	puts "Usage: webmysqltest.rb login pass database test_file_path"
	exit 0
end

begin
	dbh = Mysql.real_connect("localhost", ARGV[0], ARGV[1], ARGV[2])
	res = dbh.query("SHOW TABLES")
	f = File.new(ARGV[3], "w")
	f.puts(php_pred)
	f.puts("$globalni = array(")
	while row = res.fetch_row do
# vygenerovat php
		f.puts("\t\"" + row[0] + '"' + " => array(")
		tblres = dbh.query("DESCRIBE " + row[0])
		while col = tblres.fetch_row do
			nazev = col[0]
			f.puts("\t\t\"" + nazev + "\" => array(")
			col.each_index {|i| 
				if (i != 0)
					k = fields[i]
					v = col[i]
					if (v == nil)
						v = ""
					end
					f.puts("\t\t\t\""+k+"\"=>\""+v+"\",")
				end
			}
			f.puts("\t\t),")
		end
		tblres.free
		f.puts("\t),")
	end
	f.puts(");")
	f.puts(php_po)
	f.close
	res.free
	puts "Test struktury databaze byl vygenerovan."
rescue Mysql::Error => e
	puts "Error code: #{e.errno}"
	puts "Error message: #{e.error}"
	puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
	dbh.close if dbh
end
