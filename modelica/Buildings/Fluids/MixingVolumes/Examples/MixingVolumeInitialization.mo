within Buildings.Fluids.MixingVolumes.Examples;
model MixingVolumeInitialization

    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{180,100}}),      graphics),
                         Commands(file=
            "MixingVolumeInitialization.mos" "run"));

 package Medium = Modelica.Media.Air.SimpleAir;
 //package Medium = Buildings.Media.PerfectGases.MoistAir;
 //package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir;

  Modelica_Fluid.Sources.Boundary_pT sou1(redeclare package Medium = 
        Medium,
    p=101330,
    nPorts=1,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-60,10},{-40,30}}, rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sin1(redeclare package Medium = 
        Medium,
    p=101320,
    nPorts=1,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{120,10},{100,30}}, rotation=0)));
  Modelica_Fluid.Pipes.StaticPipe pipe1(
    redeclare package Medium = Medium,
    length=1,
    diameter=0.25) annotation (Placement(transformation(extent={{-20,10},{0,30}},
          rotation=0)));
  Modelica_Fluid.Pipes.StaticPipe pipe2(
    redeclare package Medium = Medium,
    length=1,
    diameter=0.25) annotation (Placement(transformation(extent={{60,10},{80,30}},
          rotation=0)));
  MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    V=0.1,
    nPorts=2) 
    annotation (Placement(transformation(extent={{20,20},{40,40}}, rotation=0)));
  inner Modelica_Fluid.System system 
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(sou1.ports[1], pipe1.port_a) annotation (Line(
      points={{-40,20},{-20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe1.port_b, vol1.ports[1]) annotation (Line(
      points={{0,20},{28,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol1.ports[2], pipe2.port_a) annotation (Line(
      points={{32,20},{60,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe2.port_b, sin1.ports[1]) annotation (Line(
      points={{80,20},{100,20}},
      color={0,127,255},
      smooth=Smooth.None));
end MixingVolumeInitialization;