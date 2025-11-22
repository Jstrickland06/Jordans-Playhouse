# Olive Garden Menu Normalization – Jordan Strickland

This solution takes semi-organized text copied from the Olive Garden lunch menu and turns it into a simple CSV file with three fields: item name, price, and calories.

## Files

- `myMenuScript.sh` – shell script that reads `olive_raw.txt` and outputs `my_output.csv`
- `olive_raw.txt` – raw copied text from the Olive Garden menu
- `my_output.csv` – structured CSV output created by the script

## How to run the script

```bash
./myMenuScript.sh > my_output.csv
