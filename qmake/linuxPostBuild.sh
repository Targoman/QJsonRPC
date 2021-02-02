################################################################################
#   TargomanBuildSystem
#
#   Copyright 2010-2021 by Targoman Intelligent Processing <http://tip.co.ir>
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
################################################################################
#!/bin/sh

BasePath=$1
IncludeTarget=$2
ConfigTarget=$3

# Creating a symbolic link reduces the pain of ambigious changes in headers!
#cp -vrf --parents `find $BasePath -name *.h -o -name *.hpp -o -name *.hh` $IncludeTarget || :
for File in $(find "$BasePath" -name "*.h" -o -name "*.hpp" -o -name "*.hh"); do
    SrcPath=$(dirname $File);
    SrcName=$(basename $File);
    # Check if the header is private
    if echo "$SrcPath" | egrep "\bPrivate\b" 2>&1 > /dev/null; then
        echo -e "\e[33mIgnoring private header $File ...\e[0m";
    else
        TgtPath="$IncludeTarget/$BasePath/$(python -c "import os.path; print os.path.relpath('$SrcPath', '$BasePath')")";
        SrcPath="$(python -c "import os.path; print os.path.relpath('$SrcPath', '$TgtPath')")";
        if [ -r "$TgtPath/$SrcName" ]; then
            echo -e "\e[33mAlready exists $File ...\e[0m";
        else
            mkdir -pv "$TgtPath" || : ;
            echo -e "\e[34mCreating symbolic link for $File ...\e[0m";
            # DO NOT USE $File BECAUSE THE SYMBOLIC LINK
            # MUST POINT TO A RELATIVE PATH
            ln -s "$SrcPath/$SrcName" "$TgtPath/$SrcName" || : ;
        fi
    fi
done

echo -e "\e[32mHeaders symlinked to $IncludeTarget\e[0m"

# Config files will be copied only when the exist!
if [ -d conf ]; then
    mkdir -p $ConfigTarget    || : ;
    echo -e "\e[34Copying config files ...\e[0m";
    cp -rvf "conf/"* $ConfigTarget || : ;
    echo -e "\e[32mConfigs exported to $ConfigTarget\e[0m";
else
    echo -e "\e[32mNo config files to copy\e[0m";
fi

