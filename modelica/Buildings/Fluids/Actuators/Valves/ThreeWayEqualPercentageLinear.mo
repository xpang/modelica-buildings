within Buildings.Fluids.Actuators.Valves;
model ThreeWayEqualPercentageLinear
  "Three way valve with equal percentage and linear characteristics"
    extends BaseClasses.PartialThreeWayValve(
      redeclare TwoWayEqualPercentage res1(
      redeclare package Medium = Medium,
      l=l[1],
      deltaM=deltaM,
      dp0=dp0,
      from_dp=from_dp,
      linearized=linearized[1],
      R=R,
      delta0=delta0,
      m0_flow=m0_flow,
      CvData=CvData,
      Kv_SI=Kv_SI,
      Kv=Kv,
      Cv=Cv,
      Av=Av),
      redeclare TwoWayLinear res3(
      redeclare package Medium = Medium,
      l=l[2],
      deltaM=deltaM,
      dp0=dp0,
      from_dp=from_dp,
      linearized=linearized[2],
      m0_flow=m0_flow,
      CvData=CvData,
      Kv_SI=fraK*Kv_SI,
      Kv=fraK*Kv,
      Cv=fraK*Cv,
      Av=fraK*Av));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-72,24},{-34,-20}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="%%")}),
    Documentation(info="<html>
<p>
Three way valve with equal percentage characteristics
between <tt>port_1</tt> and <tt>port_2</tt> 
and linear opening characteristic between <tt>port_1</tt> and <tt>port_2</tt>.
Such opening characteristics were typical for valves from Landis &amp; Gyr (now
Siemens).
</p><p>
This model is based on the partial valve models 
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialThreeWayValve\">
PartialThreeWayValve</a> and
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialTwoWayValve\">
PartialTwoWayValve</a>. 
See
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialThreeWayValve\">
PartialThreeWayValve</a>
for the implementation of the three way valve
and see
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialTwoWayValve\">
PartialTwoWayValve</a>
for the implementation of the leakage flow or 
the regularization near the origin.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 16, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  parameter Real R = 50 "Rangeability, R=50...100 typically";
  parameter Real delta0 = 0.01
    "Range of significant deviation from equal percentage law";

equation
  connect(inv.y, res3.y) annotation (Line(points={{-35,72},{20,72},{20,-74},{8,
          -74},{8,-62}}, color={0,0,127}));
  connect(y, inv.u2) annotation (Line(points={{-120,80},{-92,80},{-92,40},{-44,
          40},{-44,64}}, color={0,0,127}));
  connect(y, res1.y) annotation (Line(points={{-120,80},{-92,80},{-92,8},{-62,8}},
        color={0,0,127}));
end ThreeWayEqualPercentageLinear;