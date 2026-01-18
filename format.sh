#!/bin/bash

echo "Formatting code with ptop..."
for file in src/*.pas src/*.lpr; do
    ptop -c ptop.cfg "$file" "$file.formatted"
    mv "$file.formatted" "$file"
    echo "   Processed: $file"
done

echo "Done."
