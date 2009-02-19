within Buildings.Fluids.Boilers.Examples;
model BoilerPolynomial "Test model"
 package Medium = Buildings.Media.ConstantPropertyLiquidWater "Medium model";
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics),
          Commands(file=
          "BoilerPolynomial.mos" "run"),
    experiment(StopTime=3600),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})));
 parameter Modelica.SIunits.Power Q0_flow = 3000 "Nominal power";
 parameter Modelica.SIunits.Temperature dT0 = 20
    "Nominal temperature difference";
 parameter Modelica.SIunits.MassFlowRate m0_flow = Q0_flow/dT0/4200
    "Nominal mass flow rate";
 parameter Modelica.SIunits.Pressure dp0 = 3000 "Pressure drop at m0_flow";
  inner Modelica_Fluid.System system 
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Modelica_Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=2,
    p(displayUnit="Pa") = 300000,
    T=333.15) "Sink" 
    annotation (Placement(transformation(extent={{90,-68},{70,-48}})));
  Modelica_Fluid.Sources.Boundary_pT sou(
    nPorts=2,
    redeclare package Medium = Medium,
    p=300000 + dp0,
    T=303.15) 
    annotation (Placement(transformation(extent={{-84,-68},{-64,-48}})));
  Modelica.Blocks.Sources.TimeTable y(table=[0,0; 1800,1; 1800,0; 2400,0; 2400,
        1; 3600,1]) 
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Fluids.Boilers.BoilerPolynomial fur1(
    a={0.9},
    effCur=Buildings.Fluids.Types.EfficiencyCurves.Constant,
    Q0_flow=Q0_flow,
    dT0=dT0,
    T_start=293.15,
    redeclare package Medium = Medium) "Boiler" 
    annotation (Placement(transformation(extent={{-10,-2},{10,18}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAmb1(
                                                              T=288.15)
    "Ambient temperature in boiler room" 
    annotation (Placement(transformation(extent={{-30,28},{-10,48}})));
  Buildings.Fluids.Boilers.BoilerPolynomial fur2(
    a={0.9},
    effCur=Buildings.Fluids.Types.EfficiencyCurves.Constant,
    Q0_flow=Q0_flow,
    dT0=dT0,
    redeclare package Medium = Medium,
    energyDynamics=Modelica_Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica_Fluid.Types.Dynamics.SteadyState,
    T_start=293.15) "Boiler" 
    annotation (Placement(transformation(extent={{-12,-70},{8,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAmb2(
                                                              T=288.15)
    "Ambient temperature in boiler room" 
    annotation (Placement(transformation(extent={{-32,-40},{-12,-20}})));
  FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium,
    m0_flow=m0_flow,
    dp0=dp0) annotation (Placement(transformation(extent={{20,-2},{40,18}})));
  FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = Medium,
    m0_flow=m0_flow,
    dp0=dp0) annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=0.1) 
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
equation
  connect(TAmb1.port, fur1.heatPort) 
                                   annotation (Line(
      points={{-10,38},{0,38},{0,15.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAmb2.port, fur2.heatPort) 
                                   annotation (Line(
      points={{-12,-30},{-2,-30},{-2,-52.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sou.ports[1], fur1.port_a) annotation (Line(
      points={{-64,-56},{-36,-56},{-36,8},{-10,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], fur2.port_a) annotation (Line(
      points={{-64,-60},{-12,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fur1.port_b, res1.port_a) annotation (Line(
      points={{10,8},{20,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fur2.port_b, res2.port_a) annotation (Line(
      points={{8,-60},{20,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, sin.ports[1]) annotation (Line(
      points={{40,8},{56,8},{56,-56},{70,-56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_b, sin.ports[2]) annotation (Line(
      points={{40,-60},{70,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y, firstOrder.u) annotation (Line(
      points={{-79,-20},{-75.5,-20},{-75.5,-20},{-72,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, fur1.y) annotation (Line(
      points={{-49,-20},{-40,-20},{-40,16},{-12,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, fur2.y) annotation (Line(
      points={{-49,-20},{-40,-20},{-40,-52},{-14,-52}},
      color={0,0,127},
      smooth=Smooth.None));
end BoilerPolynomial;