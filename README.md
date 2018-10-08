# Coffee Bean Hopper Extension for Breville "The Grind Control"

This is an parametric coffee hopper extension for Breville's "The Grind Control" coffee maker

**Warning:** I have not got a chance to print this design yet. Once I do I will update this with any changes required and slicer settings used.

## How this was designed:
### Generating the DXF for use in OpenSCAD
- Scan bottom piece of hopper on a flatbed scanner
  - It took several tries to get the lighting right to make the edge easy to trace. I put white paper inside and around it while scanning and a flashlight aimed down on it.
  - Scanned at 600 dpi color
- Open PDF in inkscape
- Set Units and Default units to mm in Document Properties
- Save as an inkscape SVG
- Add a new layer and use the line/bezier tool to make a path tracing the outside of the lip
  - I started off with a bunch of line segments then used remove node and auto-smooth to get a smooth path
  - I then found the center X and added nodes there making sure they would look right when it was mirrored
  - Deleted all line segments and nodes to the right of center
  - Use Create Tiled Clone to copy the path with reflection symmentry
  - Select each set of center nodes and Join them.
- Duplicate this layer
- Select the path and use the Flatten Beziers Extension to convert to line segments.
  - I used flatness 0.1
  - This is done becuase openscad can not handle splines in DXF files.
- Make the layer with the Flattened Beziers the only visable layer
- Use the Select tool to select the path and Set X and Y to 0 in the toolbar.
- Make a note of W and H to refrence in the SCAD file.
- Save a copy as a DXF R14
  - Make sure Base Unit is mm and Layer export is Visible Only

### How the scad file works
- Variables to define all dimensions and numbers
    - `lipH` and `lipW` are measured on the bottom of the hopper.
      - We use the height to make the top and bottom fit properly, we don't need the width but you would use it as the wall width to try to get them flush.
    - `dxfX` and `dxfY` are taked from the svg/dxf.
      - We use these to center the object and to calculuate a scale factor for `linear_extrude`.
    - `Btolerance` is somewhat made up, I measured the Y distance from outside edges of the bottome lip and complated that too `dxfY`, divided it by 2 and added a little extra so it's not too snug.
    - `height` is how high the middle section is. The total height added when using this is `height + lipH`
    - `width` is the width of the walls on the top and bottom section. The middle will taper from `width` to `width * 2`
- `module outline` imports and centers the DXF and give the option of offsetting it
- The part is made of 3 sections
  - The bottom:
    - `linear_extrude` the difference between an outline ofsetted by `Btolerance + width` and `Btolerance`.
    - This forms the part that will sit over the bottom lip of the hopper.
  - The Top:
    - `linear_extrude` the difference between an outline with no offset and one ofsetted by `width`.
    - This forms the part that the hopper lid will sit on.
  - The Middle:
    - This part is a bit more complicated becuase we need to transition smoothly from the inside of the bottom to the inside of the top.
    - Start with a `linear_extrude` of the same outside as the bottom.
    - We subtract a `linear_extrude` with a scale value to make the inside, it starts with an outline with the same offset as the inside of the bottom. We calculate X and Y scaling values by taking the total top inside dimension for X and Y divided by the bottom inside dimensions
    - We then subtract a `linear_extrude` at the same offset as the top because the corners do not scale exactly the same.

<!--- vim: set expandtab: tabstop=4 shiftwidth=4 -->