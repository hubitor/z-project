#!/usr/bin/python

import os
import json
import sys


current_dir = os.path.dirname(os.path.abspath(__file__))

if os.environ["GCS_BUCKET"]:
#GCS = 'gs://td-docker-back/terraform/state/default.tfstate'
	GCS = 'gs://'+os.environ["GCS_BUCKET"]+'/terraform/state/default.tfstate'

os.system('gsutil -q cp '+GCS+' '+current_dir+'/')

dictionary = {}
jsonout = {'_meta':{'hostvars':{}},'all':{'children':[]}}

with open(current_dir+'/default.tfstate') as terraformtf:
	dictionary = json.load(terraformtf)

for modules in dictionary['modules']:
	if modules.has_key('resources') and modules['resources']:
		for attributes in modules['resources']:
			if modules['resources'][attributes].has_key('type'):
				if modules['resources'][attributes]['type'] == 'google_compute_instance':
					instance_name = modules['resources'][attributes]['primary']['id']
					instance_ip = modules['resources'][attributes]['primary']['attributes']['network_interface.0.access_config.0.assigned_nat_ip']
					jsonout['_meta']['hostvars'][instance_name] = { 'ansible_host': instance_ip }
					group = attributes.replace('google_compute_instance.','')
					if 'app' in group:
						group='app'
					elif 'db' in group:
						group='db'
					elif 'gitlabrunner' in group:
						group='gitlabrunner'
					elif 'docker' in group:
						group='docker'
					else:
						group='ungrouped'
					if group not in jsonout['all']['children']:
						jsonout['all']['children'].append(group)
					if not jsonout.has_key(group):
						jsonout[group] = {'hosts':[]}
					jsonout[group]['hosts'].append(instance_name)

					zone = modules['resources'][attributes]['primary']['attributes']['zone']
                                        if zone not in jsonout['all']['children']:
						jsonout['all']['children'].append(zone)
					if not jsonout.has_key(zone):
                                                jsonout[zone] = {'hosts':[]}
					jsonout[zone]['hosts'].append(instance_name)

					project = modules['resources'][attributes]['primary']['attributes']['project']
                                        if project not in jsonout['all']['children']:
                                                jsonout['all']['children'].append(project)
                                        if not jsonout.has_key(project):
                                                jsonout[project] = {'hosts':[]}
                                        jsonout[project]['hosts'].append(instance_name)
					for subattributes in modules['resources'][attributes]['primary']['attributes']:
						tags = ''
						if 'tags.' in subattributes and subattributes <> 'tags.#':
							tags = 'tag_'+modules['resources'][attributes]['primary']['attributes'][subattributes]
							if tags not in jsonout['all']['children']:
								jsonout['all']['children'].append(tags)
							if not jsonout.has_key(tags):
								jsonout[tags] = {'hosts':[]}
							jsonout[tags]['hosts'].append(instance_name)
								
					

os.remove(current_dir+'/default.tfstate')

if '--list' in sys.argv:
	print json.dumps(jsonout,ensure_ascii=False)

