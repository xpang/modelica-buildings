within Buildings.Examples.DualFanDualDuct.Controls;
block RoomMixingBox "Controller for room mixing box"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter Modelica.SIunits.MassFlowRate m_flow_min "Minimum mass flow rate";
  Buildings.Controls.Continuous.LimPID conHea(
    yMax=1,
    xi_start=0.1,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    Td=60,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=60) "Controller for heating"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.Continuous.LimPID conCoo(
    yMax=1,
    reverseAction=true,
    Td=60,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=60) "Controller for cooling (acts on damper)"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Interfaces.RealInput TRoo(final quantity="ThermodynamicTemperature",
                                          final unit = "K", displayUnit = "degC", min=0)
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput yHot "Signal for hot air damper"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput yCol "Signal for cold deck air damper"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealInput mAir_flow
    "Measured air mass flow rate into the room"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.Continuous.LimPID conFloRat(
    yMax=1,
    xi_start=0.1,
    Td=60,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=20) "Controller for mass flow rate"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Modelica.Blocks.Sources.Constant mAirSet(k=m_flow_min)
    "Set point for minimum air flow rate"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Utilities.Math.SmoothMax smoothMax(deltaX=0.01)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Interfaces.RealInput TRooSetHea(unit="K")
    "Room temperature setpoint for heating"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TRooSetCoo(unit="K")
    "Room temperature setpoint for cooling"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
equation
  connect(conHea.u_m, TRoo) annotation (Line(
      points={{-10,48},{-10,40},{-80,40},{-80,80},{-120,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.u_m, TRoo) annotation (Line(
      points={{-10,-62},{-10,-80},{-80,-80},{-80,80},{-120,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mAirSet.y, conFloRat.u_s) annotation (Line(
      points={{-39,20},{-22,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mAir_flow, conFloRat.u_m) annotation (Line(
      points={{-120,-60},{-90,-60},{-90,-20},{-10,-20},{-10,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(smoothMax.y, yHot)  annotation (Line(
      points={{61,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.y, smoothMax.u1)  annotation (Line(
      points={{1,60},{20,60},{20,46},{38,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conFloRat.y, smoothMax.u2)  annotation (Line(
      points={{1,20},{20,20},{20,34},{38,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.y, yCol) annotation (Line(
      points={{1,-50},{110,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.u_s, TRooSetHea) annotation (Line(
      points={{-22,60},{-62,60},{-62,40},{-120,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.u_s, TRooSetCoo) annotation (Line(
      points={{-22,-50},{-72,-50},{-72,1.11022e-15},{-120,1.11022e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
        Text(
          extent={{-86,92},{-38,68}},
          lineColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{-90,-44},{-42,-68}},
          lineColor={0,0,127},
          textString="m_flow"),
        Text(
          extent={{42,52},{90,28}},
          lineColor={0,0,127},
          textString="yHea"),
        Text(
          extent={{46,-36},{94,-60}},
          lineColor={0,0,127},
          textString="yCoo"),
        Text(
          extent={{-84,52},{-36,28}},
          lineColor={0,0,127},
          textString="TSetH"),
        Text(
          extent={{-84,10},{-36,-14}},
          lineColor={0,0,127},
          textString="TSetC")}),
    Documentation(info="<html>
This controller outputs the control signal for the air damper for the hot deck and the cold deck.
The control signal for the hot deck is the larger of the two signals needed to track the room heating
temperature setpoint, and the minimum air flow rate.
</html>"));
end RoomMixingBox;