within Buildings.Rooms.BaseClasses;
model InfraredRadiationGainDistribution
  "Infrared radiative heat gain distribution between the room facing surfaces"
  extends Buildings.Rooms.BaseClasses.PartialSurfaceInterface;
  parameter Boolean haveShade "Set to true if a shade is present";

  Modelica.Blocks.Interfaces.RealInput uSha[NConExtWin](each min=0, each max=1) if
       haveShade
    "Control signal for the shading device (removed if no shade is present)"
    annotation (Placement(transformation(extent={{-280,160},{-240,200}}),
        iconTransformation(extent={{-280,160},{-240,200}})));

  Modelica.Blocks.Interfaces.RealInput Q_flow
    "Radiative heat input into room (positive if heat gain)"
        annotation (Placement(transformation(
        origin={-260,0},
        extent={{20,-20},{-20,20}},
        rotation=180)));
  HeatTransfer.Interfaces.RadiosityOutflow[NConExtWin] JOutConExtWin
    "Outgoing radiosity that connects to shaded and unshaded part of glass"
    annotation (Placement(transformation(extent={{240,110},{260,130}})));
protected
  Real fraConExt[NConExt] = AEpsConExt/sumAEps
    "Fraction of infrared radiant heat gain absorbed by exterior constructions";
  Real fraConExtWinOpa[NConExtWin] = AEpsConExtWinOpa/sumAEps
    "Fraction of infrared radiant heat gain absorbed by opaque part of exterior constructions that have a window";
  Real fraConExtWinGla[NConExtWin] = (AEpsConExtWinSha + AEpsConExtWinUns)/sumAEps
    "Fraction of infrared radiant heat gain absorbed by opaque part of glass constructions that have a window";
  Real fraConExtWinFra[NConExtWin] = AEpsConExtWinFra/sumAEps
    "Fraction of infrared radiant heat gain absorbed by window frame of exterior constructions that have a window";

  Real fraConPar_a[NConPar] = AEpsConPar_a/sumAEps
    "Fraction of infrared radiant heat gain absorbed by partition constructions surface a";
  Real fraConPar_b[NConPar] = AEpsConPar_b/sumAEps
    "Fraction of infrared radiant heat gain absorbed by partition constructions surface b";
  Real fraConBou[NConBou] = AEpsConBou/sumAEps
    "Fraction of infrared radiant heat gain absorbed by constructions with exterior boundary conditions exposed to outside of room model";
  Real fraSurBou[NSurBou] = AEpsSurBou/sumAEps
    "Fraction of infrared radiant heat gain absorbed by surface models of constructions that are modeled outside of this room";

 parameter Real AEpsConExt[NConExt] = {AConExt[i]*epsConExt[i] for i in 1:NConExt}
    "Absorptivity times area of exterior constructions";
 parameter Real AEpsConExtWinOpa[NConExtWin] = {AConExtWinOpa[i]*epsConExtWinOpa[i] for i in 1:NConExtWin}
    "Absorptivity times area of opaque part of exterior constructions that contain a window";
 Real AEpsConExtWinUns[NConExtWin] = {shaSig[i].yCom * AConExtWinGla[i]*epsConExtWinUns[i]
     for i in 1:NConExtWin}
    "Absorptivity times area of unshaded window constructions";
 Real AEpsConExtWinSha[NConExtWin] = {shaSig[i].y    * AConExtWinGla[i]*epsConExtWinSha[i]
    for i in 1:NConExtWin}
    "Absorptivity times area of shaded window constructions";
 parameter Real AEpsConExtWinFra[NConExtWin] = {AConExtWinFra[i]*epsConExtWinFra[i] for i in 1:NConExtWin}
    "Absorptivity times area of window frame";
 parameter Real AEpsConPar_a[NConPar] = {AConPar[i]*epsConPar_a[i] for i in 1:NConPar}
    "Absorptivity times area of partition constructions surface a";
 parameter Real AEpsConPar_b[NConPar] = {AConPar[i]*epsConPar_b[i] for i in 1:NConPar}
    "Absorptivity times area of partition constructions surface b";
 parameter Real AEpsConBou[NConBou] = {AConBou[i]*epsConBou[i] for i in 1:NConBou}
    "Absorptivity times area of constructions with exterior boundary conditions exposed to outside of room model";
 parameter Real AEpsSurBou[NSurBou] = {ASurBou[i]*epsSurBou[i] for i in 1:NSurBou}
    "Absorptivity times area of surface models of constructions that are modeled outside of this room";

 parameter Real sumAEpsNoWin(fixed=false)
    "Sum of absorptivity times area of all constructions except for windows";
 Real sumAEps
    "Sum of absorptivity times area of all constructions including windows";

 Buildings.HeatTransfer.Windows.BaseClasses.ShadingSignal shaSig[NConExtWin](
      each final haveShade=haveShade)
    "Block to constrain the shading control signal to be strictly within (0, 1) if a shade is present";
initial equation
  sumAEpsNoWin = sum(AEpsConExt)+sum(AEpsConExtWinOpa)+sum(AEpsConExtWinFra)
                +sum(AEpsConPar_a)+sum(AEpsConPar_b)+sum(AEpsConBou)+sum(AEpsSurBou);
equation
  connect(uSha, shaSig.u);

  sumAEps      = sumAEpsNoWin + sum(AEpsConExtWinUns) + sum(AEpsConExtWinSha);

  // Infrared radiative heat flow
  conExt.Q_flow    = -fraConExt*Q_flow;
  conExtWin.Q_flow = -fraConExtWinOpa*Q_flow;
  conPar_a.Q_flow  = -fraConPar_a*Q_flow;
  conPar_b.Q_flow  = -fraConPar_b*Q_flow;
  conBou.Q_flow    = -fraConBou*Q_flow;
  conSurBou.Q_flow    = -fraSurBou*Q_flow;
  // This model makes the simplification that the shade, the glass and the frame have
  // the same absorptivity in the infrared region
  JOutConExtWin        = -fraConExtWinGla*Q_flow;
  conExtWinFra.Q_flow  = -fraConExtWinFra*Q_flow;
  // Check for conservation of energy
  assert(abs(1 - sum(fraConExt) - sum(fraConExtWinOpa)- sum(fraConExtWinGla) - sum(fraConExtWinFra)
           - sum(fraConPar_a) - sum(fraConPar_b)
           - sum(fraConBou) - sum(fraSurBou))  < 1E-5,
           "Programming error: Radiation balance is wrong. Check equations.");
  annotation (
preferredView="info",
Documentation(info = "<html>
This model computes the distribution of the infrared radiant heat gain
to the room surfaces. 
The infrared radiant heat gain <i>Q</i> is an input to this model.
It is distributed to the individual surfaces according to
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q<sup>i</sup> = Q &nbsp; A<sup>i</sup> &nbsp; &epsilon;<sup>i</sup> &frasl; 
 &sum;<sub>k</sub> A<sup>k</sup> &nbsp; &epsilon;<sup>k</sup>.
</p>
<p>
For opaque surfaces, the heat flow rate 
<i>Q<sup>i</sup></i> 
is set to be equal to the heat flow rate at the heat port.
For the glass of the windows, the heat flow rate 
<i>Q<sup>i</sup></i> is set to the radiosity
<i>J<sup>i</sup></i>
that will strike the glass or the window shade.
<p/>
</html>",
        revisions="<html>
<ul>
<li>
December 1, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Text(
          extent={{-234,40},{-178,10}},
          lineColor={0,0,127},
          textString="Q_flow"),
        Rectangle(
          extent={{-242,4},{-2,-4}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,4},{2,-8}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-144,-8},{146,-8}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{2,-200},{2,184}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Text(
          extent={{-230,210},{-174,148}},
          lineColor={0,0,127},
          textString="uSha")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-240,-240},{240,
            240}}),
            graphics));
end InfraredRadiationGainDistribution;
