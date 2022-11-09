# -*- coding: utf-8 -*-

from dataclasses import dataclass
from types import new_class
import unittest
from typing import Container, Iterable, Sequence

import cx_Oracle

import sqlalchemy as sa
import sqlalchemy.orm as sorm


from sqlalchemy import Column, String, Integer, Numeric, DateTime, create_engine

Base = sorm.declarative_base()

@dataclass
class DeviceInFlow:
    name: str
    position: int
    direction: bool

class FlWeightOpcItem(Base):
    __tablename__ = "FL_WGT_OPC_ITEMS"

    scale_name = Column("DEVICENAME", String(30), primary_key=True)
    sequence = Column("ITEM_SEQ", Integer, primary_key=True)
    item_code = Column("ITEM_CODE", String(60))

class BasicFlow(Base):
    __tablename__ = "FL_BASIC"

    name = Column("FP_NAME", String(200))
    number = Column("FP_NO", String(10), primary_key=True)

    source_position = Column("STRT_POSITION", String(100))
    source_yard = Column("STRT_YARD", String(20))
    source_device_name = Column("STRT_DEVICE", String(30))
    source_type_code = Column("STRT_TYPE", String(1))

    destination_position = Column("FIN_POSITION", String(100))
    destination_yard = Column("FIN_YARD", String(20))
    destination_device_name = Column("FIN_DEVICE", String(30))
    destination_type_code = Column("FIN_TYPE", String(1))

    special_unique_id = Column("FP_SPECIAL", String(200))
    key_device_str = Column("KEY_DEVICE", String(200))
    operation_area = Column("OPER_AREA", String(2))

    length = Column("FP_DISTANCE", Numeric(5, 1))
    power = Column("FP_POWER", Numeric(10, 1))

    device_total = Column("DEVICETOTAL", String(2))

    dev_no1 = Column("DEV_NO1", String(15))

    dev_pos1 = Column("POSITION1", String(2))
    dev_dir1 = Column("DIRECTION1", String(1))
    dev_no2 = Column("DEV_NO2", String(15))
    dev_pos2 = Column("POSITION2", String(2))
    dev_dir2 = Column("DIRECTION2", String(1))
    dev_no3 = Column("DEV_NO3", String(15))
    dev_pos3 = Column("POSITION3", String(2))
    dev_dir3 = Column("DIRECTION3", String(1))
    dev_no4 = Column("DEV_NO4", String(15))
    dev_pos4 = Column("POSITION4", String(2))
    dev_dir4 = Column("DIRECTION4", String(1))
    dev_no5 = Column("DEV_NO5", String(15))
    dev_pos5 = Column("POSITION5", String(2))
    dev_dir5 = Column("DIRECTION5", String(1))
    dev_no6 = Column("DEV_NO6", String(15))
    dev_pos6 = Column("POSITION6", String(2))
    dev_dir6 = Column("DIRECTION6", String(1))
    dev_no7 = Column("DEV_NO7", String(15))
    dev_pos7 = Column("POSITION7", String(2))
    dev_dir7 = Column("DIRECTION7", String(1))
    dev_no8 = Column("DEV_NO8", String(15))
    dev_pos8 = Column("POSITION8", String(2))
    dev_dir8 = Column("DIRECTION8", String(1))
    dev_no9 = Column("DEV_NO9", String(15))
    dev_pos9 = Column("POSITION9", String(2))
    dev_dir9 = Column("DIRECTION9", String(1))
    dev_no10 = Column("DEV_NO10", String(15))
    dev_pos10 = Column("POSITION10", String(2))
    dev_dir10 = Column("DIRECTION10", String(1))
    dev_no11 = Column("DEV_NO11", String(15))
    dev_pos11 = Column("POSITION11", String(2))
    dev_dir11 = Column("DIRECTION11", String(1))
    dev_no12 = Column("DEV_NO12", String(15))
    dev_pos12 = Column("POSITION12", String(2))
    dev_dir12 = Column("DIRECTION12", String(1))
    dev_no13 = Column("DEV_NO13", String(15))
    dev_pos13 = Column("POSITION13", String(2))
    dev_dir13 = Column("DIRECTION13", String(1))
    dev_no14 = Column("DEV_NO14", String(15))
    dev_pos14 = Column("POSITION14", String(2))
    dev_dir14 = Column("DIRECTION14", String(1))
    dev_no15 = Column("DEV_NO15", String(15))
    dev_pos15 = Column("POSITION15", String(2))
    dev_dir15 = Column("DIRECTION15", String(1))
    dev_no16 = Column("DEV_NO16", String(15))
    dev_pos16 = Column("POSITION16", String(2))
    dev_dir16 = Column("DIRECTION16", String(1))
    dev_no17 = Column("DEV_NO17", String(15))
    dev_pos17 = Column("POSITION17", String(2))
    dev_dir17 = Column("DIRECTION17", String(1))
    dev_no18 = Column("DEV_NO18", String(15))
    dev_pos18 = Column("POSITION18", String(2))
    dev_dir18 = Column("DIRECTION18", String(1))
    dev_no19 = Column("DEV_NO19", String(15))
    dev_pos19 = Column("POSITION19", String(2))
    dev_dir19 = Column("DIRECTION19", String(1))
    dev_no20 = Column("DEV_NO20", String(15))
    dev_pos20 = Column("POSITION20", String(2))
    dev_dir20 = Column("DIRECTION20", String(1))
    dev_no21 = Column("DEV_NO21", String(15))
    dev_pos21 = Column("POSITION21", String(2))
    dev_dir21 = Column("DIRECTION21", String(1))
    dev_no22 = Column("DEV_NO22", String(15))
    dev_pos22 = Column("POSITION22", String(2))
    dev_dir22 = Column("DIRECTION22", String(1))
    dev_no23 = Column("DEV_NO23", String(15))
    dev_pos23 = Column("POSITION23", String(2))
    dev_dir23 = Column("DIRECTION23", String(1))
    dev_no24 = Column("DEV_NO24", String(15))
    dev_pos24 = Column("POSITION24", String(2))
    dev_dir24 = Column("DIRECTION24", String(1))
    dev_no25 = Column("DEV_NO25", String(15))
    dev_pos25 = Column("POSITION25", String(2))
    dev_dir25 = Column("DIRECTION25", String(1))
    dev_no26 = Column("DEV_NO26", String(15))
    dev_pos26 = Column("POSITION26", String(2))
    dev_dir26 = Column("DIRECTION26", String(1))
    dev_no27 = Column("DEV_NO27", String(15))
    dev_pos27 = Column("POSITION27", String(2))
    dev_dir27 = Column("DIRECTION27", String(1))
    dev_no28 = Column("DEV_NO28", String(15))
    dev_pos28 = Column("POSITION28", String(2))
    dev_dir28 = Column("DIRECTION28", String(1))
    dev_no29 = Column("DEV_NO29", String(15))
    dev_pos29 = Column("POSITION29", String(2))
    dev_dir29 = Column("DIRECTION29", String(1))
    dev_no30 = Column("DEV_NO30", String(15))
    dev_pos30 = Column("POSITION30", String(2))
    dev_dir30 = Column("DIRECTION30", String(1))
    dev_no31 = Column("DEV_NO31", String(15))
    dev_pos31 = Column("POSITION31", String(2))
    dev_dir31 = Column("DIRECTION31", String(1))
    dev_no32 = Column("DEV_NO32", String(15))
    dev_pos32 = Column("POSITION32", String(2))
    dev_dir32 = Column("DIRECTION32", String(1))
    dev_no33 = Column("DEV_NO33", String(15))
    dev_pos33 = Column("POSITION33", String(2))
    dev_dir33 = Column("DIRECTION33", String(1))
    dev_no34 = Column("DEV_NO34", String(15))
    dev_pos34 = Column("POSITION34", String(2))
    dev_dir34 = Column("DIRECTION34", String(1))
    dev_no35 = Column("DEV_NO35", String(15))
    dev_pos35 = Column("POSITION35", String(2))
    dev_dir35 = Column("DIRECTION35", String(1))
    dev_no36 = Column("DEV_NO36", String(15))
    dev_pos36 = Column("POSITION36", String(2))
    dev_dir36 = Column("DIRECTION36", String(1))
    dev_no37 = Column("DEV_NO37", String(15))
    dev_pos37 = Column("POSITION37", String(2))
    dev_dir37 = Column("DIRECTION37", String(1))
    dev_no38 = Column("DEV_NO38", String(15))
    dev_pos38 = Column("POSITION38", String(2))
    dev_dir38 = Column("DIRECTION38", String(1))
    dev_no39 = Column("DEV_NO39", String(15))
    dev_pos39 = Column("POSITION39", String(2))
    dev_dir39 = Column("DIRECTION39", String(1))
    dev_no40 = Column("DEV_NO40", String(15))
    dev_pos40 = Column("POSITION40", String(2))
    dev_dir40 = Column("DIRECTION40", String(1))
    dev_no41 = Column("DEV_NO41", String(15))
    dev_pos41 = Column("POSITION41", String(2))
    dev_dir41 = Column("DIRECTION41", String(1))
    dev_no42 = Column("DEV_NO42", String(15))
    dev_pos42 = Column("POSITION42", String(2))
    dev_dir42 = Column("DIRECTION42", String(1))
    dev_no43 = Column("DEV_NO43", String(15))
    dev_pos43 = Column("POSITION43", String(2))
    dev_dir43 = Column("DIRECTION43", String(1))
    dev_no44 = Column("DEV_NO44", String(15))
    dev_pos44 = Column("POSITION44", String(2))
    dev_dir44 = Column("DIRECTION44", String(1))
    dev_no45 = Column("DEV_NO45", String(15))
    dev_pos45 = Column("POSITION45", String(2))
    dev_dir45 = Column("DIRECTION45", String(1))
    dev_no46 = Column("DEV_NO46", String(15))
    dev_pos46 = Column("POSITION46", String(2))
    dev_dir46 = Column("DIRECTION46", String(1))
    dev_no47 = Column("DEV_NO47", String(15))
    dev_pos47 = Column("POSITION47", String(2))
    dev_dir47 = Column("DIRECTION47", String(1))
    dev_no48 = Column("DEV_NO48", String(15))
    dev_pos48 = Column("POSITION48", String(2))
    dev_dir48 = Column("DIRECTION48", String(1))
    dev_no49 = Column("DEV_NO49", String(15))
    dev_pos49 = Column("POSITION49", String(2))
    dev_dir49 = Column("DIRECTION49", String(1))
    dev_no50 = Column("DEV_NO50", String(15))
    dev_pos50 = Column("POSITION50", String(2))
    dev_dir50 = Column("DIRECTION50", String(1))
    dev_no51 = Column("DEV_NO51", String(15))
    dev_pos51 = Column("POSITION51", String(2))
    dev_dir51 = Column("DIRECTION51", String(1))
    dev_no52 = Column("DEV_NO52", String(15))
    dev_pos52 = Column("POSITION52", String(2))
    dev_dir52 = Column("DIRECTION52", String(1))
    dev_no53 = Column("DEV_NO53", String(15))
    dev_pos53 = Column("POSITION53", String(2))
    dev_dir53 = Column("DIRECTION53", String(1))
    dev_no54 = Column("DEV_NO54", String(15))
    dev_pos54 = Column("POSITION54", String(2))
    dev_dir54 = Column("DIRECTION54", String(1))
    dev_no55 = Column("DEV_NO55", String(15))
    dev_pos55 = Column("POSITION55", String(2))
    dev_dir55 = Column("DIRECTION55", String(1))
    dev_no56 = Column("DEV_NO56", String(15))
    dev_pos56 = Column("POSITION56", String(2))
    dev_dir56 = Column("DIRECTION56", String(1))
    dev_no57 = Column("DEV_NO57", String(15))
    dev_pos57 = Column("POSITION57", String(2))
    dev_dir57 = Column("DIRECTION57", String(1))
    dev_no58 = Column("DEV_NO58", String(15))
    dev_pos58 = Column("POSITION58", String(2))
    dev_dir58 = Column("DIRECTION58", String(1))
    dev_no59 = Column("DEV_NO59", String(15))
    dev_pos59 = Column("POSITION59", String(2))
    dev_dir59 = Column("DIRECTION59", String(1))
    dev_no60 = Column("DEV_NO60", String(15))
    dev_pos60 = Column("POSITION60", String(2))
    dev_dir60 = Column("DIRECTION60", String(1))
    dev_no61 = Column("DEV_NO61", String(15))
    dev_pos61 = Column("POSITION61", String(2))
    dev_dir61 = Column("DIRECTION61", String(1))
    dev_no62 = Column("DEV_NO62", String(15))
    dev_pos62 = Column("POSITION62", String(2))
    dev_dir62 = Column("DIRECTION62", String(1))
    dev_no63 = Column("DEV_NO63", String(15))
    dev_pos63 = Column("POSITION63", String(2))
    dev_dir63 = Column("DIRECTION63", String(1))
    dev_no64 = Column("DEV_NO64", String(15))
    dev_pos64 = Column("POSITION64", String(2))
    dev_dir64 = Column("DIRECTION64", String(1))

    @property
    def device_number(self) -> int:
        return int(str(self.device_total))

    @property
    def devices(self) -> Sequence[DeviceInFlow]:
        devs = []
        for i in range(1, self.device_number + 1):
            dev_name = getattr(self, f"dev_no{i}")
            if dev_name is None:
                break;

            dev_dir = getattr(self, f"dev_dir{i}")
            dev_pos = getattr(self, f"dev_pos{i}")

            dev = DeviceInFlow(str(dev_name), int(dev_pos), bool(dev_dir))
            devs.append(dev)

        return devs

class SAOrmQuickStartTest(unittest.TestCase):
    def __init__(self, methodName: str = ...) -> None:
        super().__init__(methodName)

    @classmethod
    def setUpClass(cls) -> None:

        cx_Oracle.init_oracle_client("/home/djn/opt/instantclient_21_1/")

        cls.engine = create_engine("oracle://mgyard:mgyl1234@10.10.0.3:1521?service_name=pdbmgyard.docker.internal",
                                    future=True,
                                    echo=True)

    @classmethod
    def tearDownClass(cls) -> None:
        cls.engine.dispose()

    def test_connect(self):
        with sorm.Session(self.engine) as sess:
            result = sess.execute(sa.text("SELECT 1 FROM DUAL"))

            for v in result:
                print(v)

    def test_flow_read_all(self) -> None:
        flows = []
        with sorm.Session(self.engine) as sess:
            flow_result = sess.scalars(sa.select(BasicFlow))

            for flow in flow_result:
                flows.append(flow)

            for fl in flows:
                print([dev.name for dev in fl.devices])

    def test_flow_read_one(self) -> None:
        with sorm.Session(self.engine) as sess:
            flow_result = sess.scalar(sa.select(BasicFlow).limit(1))

            print(flow_result.devices)

    def test_insert_update_delete_scale(self) -> None:
        with sorm.Session(self.engine) as sess:
            new_scale = FlWeightOpcItem(scale_name="AAA", sequence=123, item_code="FDS.Fdsa.df")

            sess.add(new_scale)
            sess.commit()

            saved = sess.scalar(sa.select(FlWeightOpcItem)
                        .where(FlWeightOpcItem.scale_name == new_scale.scale_name))

            self.assertEqual(new_scale, saved)

            saved.item_code = "ABC"
            sess.commit()

            updated = sess.scalar(sa.select(FlWeightOpcItem)
                        .where(FlWeightOpcItem.scale_name == new_scale.scale_name))

            self.assertEqual(saved, updated)

            sess.delete(new_scale)
            sess.commit()

            saved = sess.scalar(sa.select(FlWeightOpcItem)
                        .where(FlWeightOpcItem.scale_name == new_scale.scale_name))

            self.assertIsNone(saved)