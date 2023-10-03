package main

import (
	"database/sql"
	"fmt"
	"testing"

	_ "github.com/alexbrainman/odbc"
	_ "github.com/godror/godror"
)

var OracleDb *sql.DB

type OracleVersion struct {
	Banner string
	FullBanner string
	LegacyBanner string
	ConId float64
}

func setUp() {
	_ = getOracleConnection()
}

func tearDown() {
	OracleDb.Close()
}

func TestMain(m *testing.M) {
	setUp()
	_ = m.Run()
	tearDown()
}

func TestShowDrivers(t *testing.T) {
	drivers := sql.Drivers()

	fmt.Println(drivers)
}

func getOracleConnection() *sql.DB {
	if OracleDb == nil {
		//OracleDb, _ = sql.Open("godror", `user="DJN" password="freebird" connectString="10.10.0.3:1521/pdborcl.cisdi.com.cn"`)
		OracleDb, _ = sql.Open("odbc", "Driver={Oracle 12c ODBC driver};DBQ=10.10.0.3:1521/pdborcl.cisdi.com.cn;UID=DJN;PWD=freebird;")
	}

	return OracleDb
}

func TestSimpleConnect(t *testing.T) {
	db := getOracleConnection()

	err := db.Ping()
	if err != nil {
		t.Error(err)
	}
}

type HrCountry struct {
	CountryId string
	CountryName string
	RegionId int64
}

func TestMultiRowsRead(t *testing.T) {
	db := getOracleConnection()

	rows, err := db.Query("SELECT * FROM HR.COUNTRIES WHERE REGION_ID = ?", 30)
	defer rows.Close()

	if err != nil {
		t.Error(err)
	}

	colTypes, _ := rows.ColumnTypes()
	for _, v := range colTypes {
		fmt.Printf("%s: %v\n", v.Name(), v.ScanType())
	}

	var countries []HrCountry
	for rows.Next() {
		var country HrCountry
		rows.Scan(&country.CountryId, &country.CountryName, &country.RegionId);

		countries = append(countries, country)
	}

	fmt.Println(countries)
}

func ATestRowExecute(t *testing.T) {
	db := getOracleConnection()

	result, err := db.Exec("UPDATE HR.COUNTRIES SET COUNTRY_NAME = 'PRC' WHERE COUNTRY_NAME = ?", "PRC")
	if err != nil {
		t.Error(err)
	}

	affected, _ := result.RowsAffected()

	if affected != 1 {
		t.Errorf("Failed to update %s", "China")
	}
}

func TestSingleRowRead(t *testing.T) {
	db := getOracleConnection()

	row := db.QueryRow("SELECT BANNER, BANNER_FULL, BANNER_LEGACY, CON_ID FROM V$VERSION FETCH FIRST 1 ROWS ONLY")


	var ver OracleVersion
	if err := row.Scan(&ver.Banner, &ver.FullBanner, &ver.LegacyBanner, &ver.ConId); err == nil {
		fmt.Printf("%+v\n", ver)
	} else {
		t.Error(err)
	}
}
