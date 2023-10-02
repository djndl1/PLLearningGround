package main

import (
	"database/sql"
	"fmt"
	"log"
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
		log.Fatal("Bailing out!")
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
