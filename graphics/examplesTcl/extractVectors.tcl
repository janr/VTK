catch {load vtktcl}
if { [catch {set VTK_TCL $env(VTK_TCL)}] != 0} { set VTK_TCL "../../examplesTcl" }
if { [catch {set VTK_DATA $env(VTK_DATA)}] != 0} { set VTK_DATA "../../../vtkdata" }

# get the interactor ui
source $VTK_TCL/vtkInt.tcl
source $VTK_TCL/colors.tcl

# Create the RenderWindow, Renderer and both Actors
#
vtkRenderer ren1
vtkRenderWindow renWin
    renWin AddRenderer ren1
vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin

# create pipeline
#
vtkPLOT3DReader pl3d
    pl3d SetXYZFileName "$VTK_DATA/combxyz.bin"
    pl3d SetQFileName "$VTK_DATA/combq.bin"
    pl3d SetScalarFunctionNumber 100
    pl3d SetVectorFunctionNumber 202
    pl3d Update

vtkExtractVectorComponents vx
  vx SetInput [pl3d GetOutput]
vtkContourFilter isoVx
    isoVx SetInput [vx GetVxComponent]
    isoVx SetValue 0 .38
vtkPolyDataNormals normalsVx
    normalsVx SetInput [isoVx GetOutput]
    normalsVx SetFeatureAngle 45
vtkPolyDataMapper isoVxMapper
    isoVxMapper SetInput [normalsVx GetOutput]
    isoVxMapper ScalarVisibilityOff
    isoVxMapper ImmediateModeRenderingOn
vtkActor isoVxActor
    isoVxActor SetMapper isoVxMapper
    eval [isoVxActor GetProperty] SetColor $tomato

vtkExtractVectorComponents vy
  vy SetInput [pl3d GetOutput]
vtkContourFilter isoVy
    isoVy SetInput [vy GetVyComponent]
    isoVy SetValue 0 .38
vtkPolyDataNormals normalsVy
    normalsVy SetInput [isoVy GetOutput]
    normalsVy SetFeatureAngle 45
vtkPolyDataMapper isoVyMapper
    isoVyMapper SetInput [normalsVy GetOutput]
    isoVyMapper ScalarVisibilityOff
    isoVyMapper ImmediateModeRenderingOn
vtkActor isoVyActor
    isoVyActor SetMapper isoVyMapper
    eval [isoVyActor GetProperty] SetColor $lime_green

vtkExtractVectorComponents vz
  vz SetInput [pl3d GetOutput]
vtkContourFilter isoVz
    isoVz SetInput [vz GetVzComponent]
    isoVz SetValue 0 .38
vtkPolyDataNormals normalsVz
    normalsVz SetInput [isoVz GetOutput]
    normalsVz SetFeatureAngle 45
vtkPolyDataMapper isoVzMapper
    isoVzMapper SetInput [normalsVz GetOutput]
    isoVzMapper ScalarVisibilityOff
    isoVzMapper ImmediateModeRenderingOn
vtkActor isoVzActor
    isoVzActor SetMapper isoVzMapper
    eval [isoVzActor GetProperty] SetColor $peacock

vtkStructuredGridOutlineFilter outline
    outline SetInput [pl3d GetOutput]
vtkPolyDataMapper outlineMapper
    outlineMapper SetInput [outline GetOutput]
vtkActor outlineActor
    outlineActor SetMapper outlineMapper

# Add the actors to the renderer, set the background and size
#
ren1 AddActor outlineActor
ren1 AddActor isoVxActor
isoVxActor AddPosition 0 12 0
ren1 AddActor isoVyActor
ren1 AddActor isoVzActor
isoVzActor AddPosition 0 -12 0
ren1 SetBackground .8 .8 .8
renWin SetSize 321 321

[ren1 GetActiveCamera] SetPosition -63.3093 -1.55444 64.3922
[ren1 GetActiveCamera] SetFocalPoint 8.255 0.0499763 29.7631
[ren1 GetActiveCamera] SetViewAngle 30
[ren1 GetActiveCamera] SetViewUp 0 0 1
ren1 ResetCameraClippingRange

# render the image
#
iren SetUserMethod {wm deiconify .vtkInteract}

renWin Render
#renWin SetFileName "extractVectors.tcl.ppm"
#renWin SaveImageAsPPM

# prevent the tk window from showing up then start the event loop
wm withdraw .


