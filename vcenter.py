import re
import ssl
import sys
from pysphere import VIServer


def vcenter_conn(host, username, password):

    # if your vcenter (or vsphere) have a valid ssl cert, or doesn't have cert, comment next two lines.
    default_context = ssl._create_default_https_context
    ssl._create_default_https_context = ssl._create_unverified_context

    server = VIServer()
    server.connect(host, username, password)
    return server

def get_running_vm_names(conn):
    vml = conn.get_registered_vms(status='poweredOn')
    vm_list = []
    for i in vml:
        removed_char = re.sub(r'[\x7F]','', i)
	vm_name = re.search("\]\ (.*[a-zA-z0-9_])\/",removed_char )
        vm_list.append(vm_name.group(1))
    return vm_list

def get_running_vms(conn):
    return conn.get_registered_vms(status='poweredOn')

def get_stopped_vms(conn):
    return conn.get_registered_vms(status='poweredOff')

def snapshots_by_vm(conn, vm_path):
    vm = conn.get_vm_by_path(vm_path)
    return len(vm.get_snapshots())

def get_running_vm_count(conn):
    vm_list = get_running_vms(conn)
    return len(vm_list)

def get_stopped_vm_count(conn):
    vm_list = get_stopped_vms(conn)
    return len(vm_list)
