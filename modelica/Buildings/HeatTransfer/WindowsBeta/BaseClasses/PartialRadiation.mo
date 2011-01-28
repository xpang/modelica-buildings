within Buildings.HeatTransfer.WindowsBeta.BaseClasses;
partial block PartialRadiation
  "Partial model for variables and data used in radiation calculation"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  extends Buildings.HeatTransfer.WindowsBeta.BaseClasses.RadiationBaseData;

  ////////////////// Parameters that are not used by RadiationData
  parameter Boolean haveExteriorShade
    "Set to true if window has an exterior shade";
  parameter Boolean haveInteriorShade
    "Set to true if window has an interior shade";
  parameter Modelica.SIunits.Area AWin "Area of window";

  ////////////////// Derived parameters
  final parameter Boolean haveShade=haveExteriorShade or haveInteriorShade
    "Set to true if window has a shade" annotation (Evaluate=true);
  final parameter Buildings.HeatTransfer.WindowsBeta.BaseClasses.RadiationData
    radDat(
    final N=N,
    final tauGlaSW=tauGlaSW,
    final rhoGlaSW_a=rhoGlaSW_a,
    final rhoGlaSW_b=rhoGlaSW_b,
    final tauShaSW_a=tauShaSW_a,
    final tauShaSW_b=tauShaSW_b,
    final rhoShaSW_a=rhoShaSW_a,
    final rhoShaSW_b=rhoShaSW_b)
    "Optical properties of window for different irradiation angles" annotation (
     Evaluate=true, Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Interfaces.RealInput uSha(min=0, max=1)
    "Control signal for shading (0: unshaded; 1: fully shaded)" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}),iconTransformation(
        extent={{-16,-16},{16,16}},
        rotation=90,
        origin={-2,-116})));
  Modelica.Blocks.Interfaces.RealInput HDif(quantity="RadiantEnergyFluenceRate",
      unit="W/m2") "Diffussive solar radiation" annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}),iconTransformation(extent=
           {{-130,65},{-100,95}})));
  Modelica.Blocks.Interfaces.RealInput incAng(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Incident angle" annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-130,-25},
            {-100,5}})));
  Modelica.Blocks.Interfaces.RealInput HDir(quantity="RadiantEnergyFluenceRate",
      unit="W/m2") "Direct solar radiation" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}),iconTransformation(extent=
            {{-130,25},{-100,55}})));

initial equation
  /* Current model assumes that the window only has either interior or exterior shading.
     Warn user if it has both interior and exterior shading working at the same time. 
     Allowing both shades at the same time would require rewriting part of the model. */
  assert(not (haveExteriorShade and haveInteriorShade),
    "Window radiation model does not support exterior and interior shade at the same time.");

  annotation (
    Documentation(info="<html>
The model calculates short-wave absorbance on the window. 
The calculations follow the description in Wetter (2004), Appendix A.4.3.

<h4>References</h4>
<ul>
<li>
Michael Wetter.<br>
<a href=\"http://simulationresearch.lbl.gov/wetter/download/mwdiss.pdf\">
Simulation-based Building Energy Optimization</a>.<br>
Dissertation. University of California at Berkeley. 2004.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
December 16, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(graphics),
    Icon(graphics={
        Text(
          extent={{-92,0},{-62,-20}},
          lineColor={0,0,127},
          textString="incAng"),
        Text(
          extent={{-94,84},{-70,70}},
          lineColor={0,0,127},
          textString="HDif"),
        Text(
          extent={{-96,42},{-62,30}},
          lineColor={0,0,127},
          textString="HDir"),
        Text(
          extent={{-32,-82},{22,-94}},
          lineColor={0,0,127},
          textString="uSha"),
        Polygon(
          points={{-46,66},{-46,-10},{-6,-50},{-6,22},{-46,66}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{18,64},{18,-12},{58,-52},{58,20},{18,64}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-28,2},{-18,10},{-8,0},{2,10},{12,0},{22,10},{32,-2},{40,4},
              {34,4},{38,-2},{40,4},{38,4}},
          color={255,128,0},
          smooth=Smooth.None),
        Polygon(
          points={{38,-2},{34,4},{40,4},{38,-2}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{38,-4},{46,-14},{58,-4},{66,-14},{66,-14},{76,-4},{86,-16},{
              94,-10},{88,-10},{92,-16},{94,-10},{92,-10}},
          color={255,128,0},
          smooth=Smooth.None),
        Polygon(
          points={{92,-16},{88,-10},{94,-10},{92,-16}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,8},{-30,14},{-24,14},{-26,8}},
          lineColor={255,128,0},
          smooth=Smooth.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,20},{-72,10},{-60,20},{-52,10},{-52,10},{-42,20},{-32,8},
              {-24,14},{-30,14},{-26,8},{-24,14},{-26,14}},
          color={255,128,0},
          smooth=Smooth.None)}));
end PartialRadiation;