# Blood Cell Count


<!-- PROJECT -->
<br />
<div align="center">
   <img src="images/logo.png" alt="Logo" width="80" height="80">

  <h3 align="center">Blood Cell Count</h3>

  <p align="center">
    This project was created for the purpose of calculating the number of monochrome and multicoloured cells. 
     <br />
    [See blog post](https://www.gokhanazizoglu.com/goruntu-isleme-ile-hucre-sayimi)
    <br />
  </p>
</div>

## Usage

A function called *countCell* has been created. This function takes as input parameters the image file path (ImagePath) and the cell type (ColorType =‘Monochrome' or ‘Multicoloured').

## Counting monochrome cells

In order to count monochromatic cells:
* First, the image is converted to a gray-level image (Figure 1.a).
* After that, it was transformed to binary (black and white) format (Figure 1.b).
* Before performing the cell count, it was necessary to apply improvement methods.
* Before to the opening process, which will be used to improve the image, the *imFill* function was used to fill the holes in the cells, ensuring that they did not lose their integrity (Figure 1.c).
* Then, the opening process was performed using the *imopen* and *bwareaopen* functions (Figure 1.e).

The parameters used in the improvement functions were determined empirically.

### *Fig. 1* Image enhancement processes

![ImageEnhancementProcesses](https://github.com/azizoglu/BloodCellCount/blob/main/images/fig1.png?raw=true)

### *Fig. 2* Monochrome cells counted in the test image [1]
![MonochromeCells](https://github.com/azizoglu/BloodCellCount/blob/main/images/fig2.png?raw=true)

## The problem of separating contiguous cells
The accurate counting of contiguous cells is a significant issue in cell counting. In the developed method, the watershed transformation was used to separate contiguous cells. An example implementation of a watershed transformation into an contiguous cell is shown in Figure 2. AAfter transformation, the image enhancement processes (filling and opening) were performed once more to prepare the image for counting. Finally, the cell count was estimated using the *region* function and the *centroid* features of the cell regions.

### *Fig. 3* An example implementation of a watershed transformation into an contiguous cell.
![ContiguousCell](https://github.com/azizoglu/BloodCellCount/blob/main/images/fig3.png?raw=true)

## Counting multicoloured cells

The processes performed on monochromatic cells will not enough to count multicoloured cells. For this reason, the color space of image has been transformed from RGB to L*a*b, HSV and YCbCr color spaces. Then, to count the cells of the desired dark purple or blue color, channels with prominent cells in the color spaces were chosen and threshold values were determined for each color space. This threshold value makes sure that only the cells that need to be counted remain in the black and white image. Finally, the cells recognized in the black and white image derived from the three color spaces were identified and separated from the remaining cells. After this stage, improvement and counting processes were performed similar to the processes applied in monochrome cells.

### *Fig. 4* Multicoloured cells counted in the test image [2]

![MulticolouredCells](https://github.com/azizoglu/BloodCellCount/blob/main/images/fig4.png?raw=true)

## Test Images
1. Monochrome cells test image: https://www.microscopyu.com/assets/gallery-images/pathology_hemolyticanemia20x04.jpg 
2. Multicoloured cells test image: https://www.microscopyu.com/assets/gallery-images/pathology_aml20x03.jpg


## License

Distributed under the MIT License. See `LICENSE.txt` for more information.
