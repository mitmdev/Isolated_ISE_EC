ec_dev_addr = 0x3c;
ise_dev_addr = 0x3f;

ec_cmds = new Object();
ec_regs = new Object();
ec_tmrs = new Object();
ec_bits = new Object();

ec_cmds["EC_MEASURE_EC"] = 80;
ec_cmds["EC_MEASURE_TEMP"] = 40;
ec_cmds["EC_CALIBRATE_PROBE"] = 20;
ec_cmds["EC_CALIBRATE_LOW"] = 10;
ec_cmds["EC_CALIBRATE_HIGH"] = 8;
ec_cmds["EC_READ"] = 2;
ec_cmds["EC_WRITE"] = 1;

ec_regs["EC_VERSION_REGISTER"] = [0, 'EC_VERSION_REGISTER', false];
ec_regs["EC_MS_REGISTER"] = [1, 'EC_MS_REGISTER', true];
ec_regs["EC_TEMP_REGISTER"] = [5, 'EC_TEMP_REGISTER', true];
ec_regs["EC_SOLUTION_REGISTER"] = [9, 'EC_SOLUTION_REGISTER', true];
ec_regs["EC_TEMPCOEF_REGISTER"] = [13, 'EC_TEMPCOEF_REGISTER', true];
ec_regs["EC_CALIBRATE_REFHIGH_REGISTER"] = [17, 'EC_CALIBRATE_REFHIGH_REGISTER', true];
ec_regs["EC_CALIBRATE_REFLOW_REGISTER"] = [21, 'EC_CALIBRATE_REFLOW_REGISTER', true];
ec_regs["EC_CALIBRATE_READHIGH_REGISTER"] = [25, 'EC_CALIBRATE_READHIGH_REGISTER', true];
ec_regs["EC_CALIBRATE_READLOW_REGISTER"] = [29, 'EC_CALIBRATE_READLOW_REGISTER', true];
ec_regs["EC_CALIBRATE_OFFSET_REGISTER"] = [33, 'EC_CALIBRATE_OFFSET_REGISTER', true];
ec_regs["EC_SALINITY_PSU"] = [37, 'EC_SALINITY_PSU', true];
ec_regs["EC_RAW_REGISTER"] = [41, 'EC_RAW_REGISTER', true];
ec_regs["EC_TEMP_COMPENSATION_REGISTER"] = [45, 'EC_TEMP_COMPENSATION_REGISTER', true];
ec_regs["EC_BUFFER_REGISTER"] = [49, 'EC_BUFFER_REGISTER', true];
ec_regs["EC_FW_VERSION_REGISTER"] = [53, 'EC_FW_VERSION_REGISTER', false];
ec_regs["EC_CONFIG_REGISTER"] = [54, 'EC_CONFIG_REGISTER', null];
ec_regs["EC_TASK_REGISTER"] = [55, 'EC_TASK_REGISTER', false];

ec_tmrs["EC_EC_MEASUREMENT_TIME"] = 750;
ec_tmrs["EC_TEMP_MEASURE_TIME"] = 750;

ec_bits["EC_TEMP_COMPENSATION_CONFIG_BIT"] = 1;
ec_bits["EC_DUALPOINT_CONFIG_BIT"] = 0;

ise_cmds = new Object();
ise_regs = new Object();
ise_tmrs = new Object();
ise_bits = new Object();

ise_cmds["ISE_MEASURE_MV"] = 80;
ise_cmds["ISE_MEASURE_TEMP"] = 40;
ise_cmds["ISE_CALIBRATE_SINGLE"] = 20;
ise_cmds["ISE_CALIBRATE_LOW"] = 10;
ise_cmds["ISE_CALIBRATE_HIGH"] = 8;
ise_cmds["ISE_MEMORY_READ"] = 2;
ise_cmds["ISE_MEMORY_WRITE"] = 4;

ise_regs["ISE_VERSION_REGISTER"] = [0, 'ISE_VERSION_REGISTER', false];
ise_regs["ISE_MV_REGISTER"] = [1, 'ISE_MV_REGISTER', true];
ise_regs["ISE_TEMP_REGISTER"] = [5, 'ISE_TEMP_REGISTER', true];
ise_regs["ISE_CALIBRATE_SINGLE_REGISTER"] = [9, 'ISE_CALIBRATE_SINGLE_REGISTER', true];
ise_regs["ISE_CALIBRATE_REFHIGH_REGISTER"] = [13, 'ISE_CALIBRATE_REFHIGH_REGISTER', true];
ise_regs["ISE_CALIBRATE_REFLOW_REGISTER"] = [17, 'ISE_CALIBRATE_REFLOW_REGISTER', true];
ise_regs["ISE_CALIBRATE_READHIGH_REGISTER"] = [21, 'ISE_CALIBRATE_READHIGH_REGISTER', true];
ise_regs["ISE_CALIBRATE_READLOW_REGISTER"] = [25, 'ISE_CALIBRATE_READLOW_REGISTER', true];
ise_regs["ISE_SOLUTION_REGISTER"] = [29, 'ISE_SOLUTION_REGISTER', true];
ise_regs["ISE_BUFFER_REGISTER"] = [33, 'ISE_BUFFER_REGISTER', true];
ise_regs["ISE_FW_VERSION_REGISTER"] = [37, 'ISE_FW_VERSION_REGISTER', false];
ise_regs["ISE_CONFIG_REGISTER"] = [38, 'ISE_CONFIG_REGISTER', null];
ise_regs["ISE_TASK_REGISTER"] = [39, 'ISE_TASK_REGISTER', false];

ise_tmrs["ISE_TEMP_MEASURE_TIME"] = 750;
ise_tmrs["ISE_MV_MEASURE_TIME"] = 250 ;

ise_bits["ISE_TEMP_COMPENSATION_CONFIG_BIT"] = 1;
ise_bits["ISE_DUALPOINT_CONFIG_BIT"] = 0;


/*
--api.measure(0x3c, 55, 40, 5, 750, '/ec/temp')
--api.measure(0x3c, 55, 80, 1, 750, '/ec/ec')
--api.measure(0x3f, 39, 40, 5, 750, '/ise/temp')
--api.measure(0x3f, 39, 80, 1, 250, '/ise/ph')
--api.setTemp(0x3c, 5, tempC, '/ec/set/temp')
--api.setTemp(0x3f, 5, tempC, '/ise/set/temp')
--api.useTemperatureCompensation(0x3c, 1, 54, ecprobe true|false)
--api.useTemperatureCompensation(0x3f, 1, 38, ecprobe true|false)
--api.getTemperatureCompensation(0x3c, 54, '/ec/temp/compensation')
--api.getTemperatureCompensation(0x3f, 38, '/ise/temp/compensation')
--api.setTempConstant(ecprobe true|false)
--api.getTempConstant()
--api.setTempCoefficient(temp_coef)
--api.getTempCoefficient()
--api.reset(dev_addr, ecprobe true|false, topic)
--api.getCalibrate(0x3c, 33, '/ec/calibrate/offset')
--api.getCalibrate(0x3f, 9, '/ise/calibrate/offset')
--api.getCalibrate(0x3c, 17, '/ec/calibrate/ref/high')
--api.getCalibrate(0x3f, 13, 'ise/calibrate/ref/high')
--api.getCalibrate(0x3c, 21, '/ec/calibrate/ref/low')
--api.getCalibrate(0x3f, 17, '/ise/calibrate/ref/low')
--api.getCalibrate(0x3c, 25, '/ec/calibrate/read/high')
--api.getCalibrate(0x3f, 21, '/ise/calibrate/read/high')
--api.getCalibrate(0x3c, 29, '/ec/calibrate/read/low')
--api.getCalibrate(0x3f, 25, '/ise/calibrate/read/low')
--api.calibration(solution, ecprobe) -- used internally
--api.calibrate(0x3c, 55, 20, 750, solution, true, '/ec/calibrate/single')
--api.calibrate(0x3f, 39, 20, 250, solution, false, '/ise/calibrate/single')
--api.calibrate(0x3c, 55, 10, 750, solution, true, '/ec/calibrate/low')
--api.calibrate(0x3f, 39, 10, 250, solution, false, '/ise/calibrate/low')
--api.calibrate(0x3c, 55, 8, 750, solution, true, '/ec/calibrate/high')
--api.calibrate(0x3f, 39, 8, 250, solution, false, '/ise/calibrate/high')
--api.setDualPointCalibration(refLow, refHigh, readLow, readHigh, ecprobe true|false)
--api.setCalibrateOffset(offset)
--api.getFirmware(0x3c, 53, '/ec/firmware')
--api.getFirmware(0x3f, 37, '/ise/firmware')
--api.getVersion(0x3c, 0, '/ec/version')
--api.getVersion(0x3f, 0, '/ise/version')
*/


var ise = [];
//ise["addr"] = 0x3f; 
ise["/ise/temp"] = "api.measure(0x3f, 39, 40, 5, 750, '/ise/temp')";
ise["/ise/ph"] = "api.measure(0x3f, 39, 80, 1, 250, '/ise/ph')";
ise["/ise/temp/compensation"] = "api.getTemperatureCompensation(0x3f, 38, '/ise/temp/compensation')";
ise["/ise/calibrate/offset"] = "api.getCalibrate(0x3f, 9, '/ise/calibrate/offset')";
ise["/ise/calibrate/ref/high"] = "api.getCalibrate(0x3f, 13, '/ise/calibrate/ref/high')";
ise["/ise/calibrate/ref/low"] = "api.getCalibrate(0x3f, 17, '/ise/calibrate/ref/low')";
ise["/ise/calibrate/read/high"] = "api.getCalibrate(0x3f, 21, '/ise/calibrate/read/high')";
ise["/ise/calibrate/read/low"] = "api.getCalibrate(0x3f, 25, '/ise/calibrate/read/low')";
ise["/ise/firmware"] = "api.getFirmware(0x3f, 37, '/ise/firmware')";
ise["/ise/version"] = "api.getVersion(0x3f, 0, '/ise/version')";


var ec = [];
//ec["addr"] = 0x3c;
ec["/ec/temp"] = "api.measure(0x3c, 55, 40, 5, 750, '/ec/temp')";
ec["/ec/ec"] = "api.measure(0x3c, 55, 80, 1, 750, '/ec/ec')";
ec["/ec/temp/compensation"] = "api.getTemperatureCompensation(0x3c, 54, '/ec/temp/compensation')";
ec["/ec/temp/constant"] = "api.getTempConstant()";
ec["/ec/temp/coefficient"] = "api.getTempCoefficient()";
ec["/ec/calibrate/offset"] = "api.getCalibrate(0x3c, 33, '/ec/calibrate/offset')";
ec["/ec/calibrate/ref/high"] = "api.getCalibrate(0x3c, 17, '/ec/calibrate/ref/high')";
ec["/ec/calibrate/ref/low"] = "api.getCalibrate(0x3c, 21, '/ec/calibrate/ref/low')";
ec["/ec/calibrate/read/high"] = "api.getCalibrate(0x3c, 25, '/ec/calibrate/read/high')";
ec["/ec/calibrate/read/low"] = "api.getCalibrate(0x3c, 29, '/ec/calibrate/read/low')";
ec["/ec/firmware"] = "api.getFirmware(0x3c, 53, '/ec/firmware')";
ec["/ec/version"] = "api.getVersion(0x3c, 0, '/ec/version')";

