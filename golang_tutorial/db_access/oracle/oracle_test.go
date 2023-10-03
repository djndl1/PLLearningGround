package main

import (
	"database/sql"
	"fmt"
	"testing"
	_ "github.com/godror/godror"
)

var OracleDb *sql.DB

type OracleVersion struct {
	Banner string
	FullBanner string
	LegacyBanner string
	ConId int32
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
		OracleDb, _ = sql.Open("godror", `user="DJN" password="freebird" connectString="10.10.0.3:1521/pdborcl.cisdi.com.cn"`)
	}

	return OracleDb
}

func TestSimpleConnect(t *testing.T) {
	db := getOracleConnection()

	err := db.Ping()
	if err != nil {
		t.Error("Bailing out!")
	}
}

type HrCountry struct {
	CountryId string
	CountryName string
	RegionId int64
}

func TestMultiRowsRead(t *testing.T) {
	db := getOracleConnection()

	var regionId int64 = 30
	rows, err := db.Query("SELECT * FROM HR.COUNTRIES WHERE REGION_ID IN (:RegionId)", regionId)
	defer rows.Close()

	if err != nil {
		t.Error("Failed to query")
	}

	var countries []HrCountry
	for rows.Next() {
		var country HrCountry
		rows.Scan(&country.CountryId, &country.CountryName, &country.RegionId);

		countries = append(countries, country)
	}

	fmt.Println(countries)
}

func TestRowExecute(t *testing.T) {
	db := getOracleConnection()

	result, err := db.Exec("UPDATE HR.COUNTRIES SET COUNTRY_NAME = 'PRC' WHERE COUNTRY_NAME = :CountryName", "China")
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
