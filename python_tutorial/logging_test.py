import logging
from logging.handlers import TimedRotatingFileHandler

logger = logging.getLogger(__name__)
logging.basicConfig(filename="logs/logging_test.log",
                    level=logging.DEBUG,
                    encoding='utf-8',
                    format='{asctime}:{levelname}:{name}:{message}',
                    style='{')
logger.info("Started!: %(great)d", { 'great': 1 })

try:
    logger.info("An exception")
    raise Exception("A random exception")
except:
    logger.info("Caught an exception", exc_info=True)
    logger.exception("Caught the exception again")


# custom logger
mylogger = logging.getLogger('mylogger')
myhandler = TimedRotatingFileHandler(filename='logs/logging_test_timed', when='M')
mylogger.addHandler(myhandler)
mylogger.addHandler(logging.StreamHandler())
myformatter = logging.Formatter(
                    '{asctime}:{levelname}:{name}:{message}',
                    style='{')
myhandler.setFormatter(myformatter)
mylogger.setLevel(logging.INFO)

mylogger.info("Mylogger")


