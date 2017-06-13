#This scrift is only used for parser c7-x86_64-comps.xml.

import os
import sys
import re

#Acording  group id like '<id>core</id>', get serial number of the group in .xml.
#the serial number will be used for xmlstarlet.
def get_group_num(group_id, xml):
    xml_lines = xml.split('\n')
    group_num = 0
    group_end_num = 0
    for xml_line in xml_lines:
        if xml_line.strip() == '<group>':
            group_num = group_num + 1           
        elif xml_line.strip() == '</group>':
            group_end_num = group_end_num + 1  
        elif xml_line.strip() == "<id>%s</id>"%group_id and group_num == group_end_num + 1:
            print group_num
            return
    print  "Do not found group: %s"%group_id

#Acording  <environment> id like '<id>kde-desktop-environment</id>', get serial number of the env in .xml.
#the serial number will be used for xmlstarlet.
def get_env_num(env_id, xml):
    xml_lines = xml.split('\n')
    env_num = 0 
    env_end_num = 0 
    for xml_line in xml_lines:
        if xml_line.strip() == '<environment>':
            env_num = env_num + 1    
        elif xml_line.strip() == '</environment>':
            env_end_num = env_end_num + 1   
        elif xml_line.strip() == "<id>%s</id>"%env_id and env_num == env_end_num + 1:
            print env_num
            return
    print  "Do not found environment: %s"%env_id

#Acording  <environment> id like '<id>kde-desktop-environment</id>',get configurations of the <environment>.
def get_env(env_id, xml):
    pattern = """<environment>
    <id>%s</id>.*?</environment>"""%env_id
    m = re.search(pattern, xml, re.S)
    print  m.group(0)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        sys.exit("Parameter not right")

    opt = sys.argv[1]
    name_id = sys.argv[2]
    src_xml = sys.argv[3]

    if os.path.exists(src_xml):
        pass
    else:
        print "File %s not exist"%src_xml

    file_src_xml = open(src_xml)
    source_xml = file_src_xml.read()

    if opt == 'get_group_num':
       get_group_num(name_id, source_xml)

    elif opt == 'get_env':
       get_env(name_id, source_xml)

    elif opt == 'get_env_num':
       get_env_num(name_id, source_xml)

    file_src_xml.close()
