within Buildings.Fluids;
package Types "Package with type definitions"
annotation (preferedView="info", Documentation(info="<html>
This package contains type definitions.
</html>"));

  type EfficiencyCurves = enumeration(
      Constant "constant",
      Polynomial "Polynomial",
      QuadraticLinear "quadratic in x1, linear in x2")
    "Enumeration to define the efficiency curves";
  type CvTypes = enumeration(
      OpPoint "flow coefficient defined by m0_flow/sqrt(dp0)",
      Kv "Kv (metric) flow coefficient",
      Cv "Cv (US) flow coefficient",
      Av "Av (metric) flow coefficient")
    "Enumeration to define the choice of valve flow coefficient" annotation (
      Documentation(info="<html>
 
<p>
Enumeration to define the choice of valve flow coefficient
(to be selected via choices menu):
</p>
 
<table border=1 cellspacing=0 cellpadding=2>
<tr><th><b>CvTypes.</b></th>
    <th><b>Meaning</b></th></tr>
 
<tr><td>OpPoint</td>
    <td>flow coefficient defined by ratio m0_flow/sqrt(dp0)</td></tr>
 
<tr><td>Kv</td>
    <td>Kv (metric) flow coefficient</td></tr>
 
<tr><td>Cv</td>
    <td>Cv (US) flow coefficient</td></tr>
 
<tr><td>Av</td>
    <td>Av (metric) flow coefficient</td></tr>

</table>

<p>
The details of the coefficients are explained in the 
<a href=\"Modelica://Modelica_Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">
   Users Guide </a>.
</p>
 
</html>"));
end Types;