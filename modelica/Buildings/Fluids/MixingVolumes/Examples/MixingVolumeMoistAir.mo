within Buildings.Fluids.MixingVolumes.Examples;
model MixingVolumeMoistAir
  import Buildings;
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -160},{180,160}}),      graphics),
                         Commands(file=
            "MixingVolumeMoistAir.mos" "run"));

// package Medium = Buildings.Media.PerfectGases.MoistAir;
   package Medium = Buildings.Media.GasesPTDecoupled.MoistAir;
  // package Medium = Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid;

  Buildings.Fluids.MixingVolumes.MixingVolumeMoistAir vol1(
    redeclare package Medium = Medium,
    V=1,
    nPorts=2,
    use_HeatTransfer=true) "Volume" 
          annotation (Placement(transformation(extent={{50,0},{70,20}},
          rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSen
    "Temperature sensor" 
    annotation (Placement(transformation(extent={{-68,82},{-48,102}}, rotation=
            0)));
  Modelica.Blocks.Sources.Constant XSet(k=0.005)
    "Set point for water mass fraction" annotation (Placement(transformation(
          extent={{-80,-60},{-60,-40}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo 
    annotation (Placement(transformation(extent={{36,120},{56,140}}, rotation=0)));
  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 20)
    "Set point for temperature" annotation (Placement(transformation(extent={{
            -80,120},{-60,140}}, rotation=0)));
  Buildings.Utilities.Psychrometrics.HumidityRatioPressure humRat
    "Conversion from humidity ratio to partial water vapor pressure" 
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}},rotation=
            0)));
  Buildings.Utilities.Psychrometrics.DewPointTemperature dewPoi
    "Dew point temperature" annotation (Placement(transformation(extent={{8,-90},
            {28,-70}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor 
    annotation (Placement(transformation(extent={{64,120},{84,140}}, rotation=0)));
  Modelica.Blocks.Continuous.Integrator QSen "Sensible heat transfer" 
    annotation (Placement(transformation(extent={{140,100},{160,120}}, rotation=
           0)));
  Modelica.Blocks.Continuous.Integrator QWat "Enthalpy of extracted water" 
    annotation (Placement(transformation(extent={{140,60},{160,80}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression HWat_flow(y=vol1.HWat_flow)
    "MoistAir heat flow rate" annotation (Placement(transformation(extent={{112,
            60},{132,80}}, rotation=0)));
  Modelica_Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    T=293.15)    annotation (Placement(transformation(extent={{-40,-10},{-20,10}},
          rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sin(        redeclare package Medium = 
        Medium,
    nPorts=1,
    T=293.15)             annotation (Placement(transformation(
        origin={140,0},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Modelica.Blocks.Continuous.LimPID PI(
    Ni=0.1,
    yMax=1000,
    k=1,
    Ti=1,
    Td=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    wd=0) 
    annotation (Placement(transformation(extent={{-40,120},{-20,140}}, rotation=
           0)));
  Modelica.Blocks.Continuous.LimPID PI1(
    Ni=0.1,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=10,
    yMax=1,
    yMin=-1,
    Td=1) 
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}}, rotation=
           0)));
  Modelica_Fluid.Sensors.MassFlowRate mIn_flow(redeclare package Medium = 
        Medium) annotation (Placement(transformation(extent={{6,-10},{26,10}},
          rotation=0)));
  Modelica_Fluid.Sensors.MassFlowRate mOut_flow(redeclare package Medium = 
        Medium) annotation (Placement(transformation(extent={{84,-10},{104,10}},
          rotation=0)));
  Modelica.Blocks.Math.Add dM_flow(k2=-1) annotation (Placement(transformation(
          extent={{140,20},{160,40}},   rotation=0)));
  Modelica.Blocks.Math.Gain gai(k=200) annotation (Placement(transformation(
          extent={{2,120},{22,140}}, rotation=0)));
  Modelica.Blocks.Math.Gain gai1(k=0.1) annotation (Placement(transformation(
          extent={{-20,-60},{0,-40}}, rotation=0)));
  inner Modelica_Fluid.System system 
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
equation
  connect(dewPoi.p_w, humRat.p_w) annotation (Line(points={{29,-80},{32,-80},{
          32,-92},{-28,-92},{-28,-103},{-19,-103}}, color={0,0,255}));
  connect(preHeaFlo.port, heatFlowSensor.port_a) 
    annotation (Line(points={{56,130},{64,130}}, color={191,0,0}));
  connect(heatFlowSensor.Q_flow, QSen.u) annotation (Line(points={{74,120},{74,
          110},{138,110}}, color={0,0,127}));
  connect(HWat_flow.y,QWat. u) annotation (Line(points={{133,70},{138,70}},
        color={0,0,127}));
  connect(TSet.y, PI.u_s) 
    annotation (Line(points={{-59,130},{-42,130}}, color={0,0,127}));
  connect(TSen.T, PI.u_m) annotation (Line(points={{-48,92},{-30,92},{-30,118}},
        color={0,0,127}));
  connect(XSet.y, PI1.u_s) annotation (Line(points={{-59,-50},{-52,-50}}, color=
         {0,0,127}));
  connect(mOut_flow.m_flow, dM_flow.u1) annotation (Line(points={{94,11},{94,36},
          {138,36}},       color={0,0,127}));
  connect(mIn_flow.m_flow, dM_flow.u2) annotation (Line(points={{16,11},{16,20},
          {16,24},{138,24}},                 color={0,0,127}));
  connect(gai.y, preHeaFlo.Q_flow) 
    annotation (Line(points={{23,130},{36,130}}, color={0,0,127}));
  connect(PI1.y, gai1.u) annotation (Line(points={{-29,-50},{-22,-50}}, color={
          0,0,127}));
  connect(gai1.y, vol1.mWat_flow) annotation (Line(points={{1,-50},{32,-50},{32,
          18},{48,18}}, color={0,0,127}));
  connect(dewPoi.T, vol1.TWat) annotation (Line(points={{7,-80},{4,-80},{4,-66},
          {42,-66},{42,14.8},{48,14.8}},
                                     color={0,0,255}));
  connect(vol1.XWat, PI1.u_m) annotation (Line(points={{72,6},{80,6},{80,-134},
          {-40,-134},{-40,-62}}, color={0,0,127}));
  connect(vol1.XWat, humRat.XWat) annotation (Line(points={{72,6},{80,6},{80,
          -134},{-28,-134},{-28,-117},{-19,-117}}, color={0,0,127}));
  connect(sou.ports[1], mIn_flow.port_a) annotation (Line(
      points={{-20,0},{6,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mOut_flow.port_b, sin.ports[1]) annotation (Line(
      points={{104,0},{117,0},{117,1.33227e-015},{130,1.33227e-015}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatFlowSensor.port_b, vol1.heatPort) annotation (Line(
      points={{84,130},{86,130},{86,40},{50,40},{50,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TSen.port, vol1.heatPort) annotation (Line(
      points={{-68,92},{-72,92},{-72,40},{50,40},{50,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mIn_flow.port_b, vol1.ports[1]) annotation (Line(
      points={{26,0},{42,0},{42,2},{60,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mOut_flow.port_a, vol1.ports[2]) annotation (Line(
      points={{84,0},{71,0},{71,-2},{60,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PI.y, gai.u) annotation (Line(
      points={{-19,130},{0,130}},
      color={0,0,127},
      smooth=Smooth.None));
end MixingVolumeMoistAir;