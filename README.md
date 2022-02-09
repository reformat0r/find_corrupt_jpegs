# find_corrupt_jpegs.sh

Finds JPEG files that lack an End-Of-Image marker and are thus corrupt (for example due to a partial/failed download).  
Such files often pass validation checks of other tools because they start with a valid file header.

## Installation

```bash
wget "https://raw.githubusercontent.com/reformat0r/find_corrupt_jpegs/master/find_corrupt_jpegs.sh" && chmod +x find_corrupt_jpegs.sh
```



## Usage

```bash
./find_corrupt_jpegs.sh outfile.txt my_photo_dir another_dir photos_*_2020
```


## Example output

```
 ▇▇▇▇▇▇▇▇▇▇▇      |  70% - 1 broken
```

## Output file

```bash
$ cat outfile.txt
my_photo_dir/foo.jpg
another_dir/bar.jpg
photos_03_2020/all_is_vibration.jpg
```

<br/><br/>


----

<br/><br/>



## Example JPEG, truncated

<img src="example_truncated.jpg" width="400">

`file` utility:
```
$ file example_truncated.jpg 
example_truncated.jpg: JPEG image data, JFIF standard 1.01, resolution (DPI), density 96x96, segment length 16, baseline, precision 8, 593x334, components 3
```

Python with `Pillow`
```python
from PIL import Image

with Image.open("example_truncated.jpg") as im:
    im.verify()    # im.transpose(Image.FLIP_LEFT_RIGHT) does raise an exception

print("File passed validation.")
```
