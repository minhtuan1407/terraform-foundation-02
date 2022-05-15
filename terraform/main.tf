#IMPORTANT - please do not nodify the inventory manually, it will be overrided from template
# The Provider block sets up the vSphere provider - How to connect to vCenter. Note the use of
# variables to avoid hardcoding credentials here
provider "vsphere" {
  user                 = var.vsphere_user_pdc
  password             = var.vsphere_password_pdc
  vsphere_server       = var.vsphere_server_pdc
  allow_unverified_ssl = true
}


# The Data sections are about determining where the virtual machine will be placed.
# Here we are naming the vSphere DC, the cluster, datastore, virtual network and the template
# name. These are called upon later when provisioning the VM resource
 
module m01-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.100"
  vm_name = "m01-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 4
  
  vm_memory_size = 8192
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module m02-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.112"
  vm_name = "m02-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 4
  
  vm_memory_size = 8192
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module m03-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.113"
  vm_name = "m03-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 4
  
  vm_memory_size = 8192
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module b01-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.101"
  vm_name = "b01-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 2
  
  vm_memory_size = 2048
  
  additional_disks = [
    { 
      size   = 15,
      number = 3     
    }
  ]
  }
 
module w01-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.102"
  vm_name = "w01-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module w02-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.103"
  vm_name = "w02-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module w03-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.104"
  vm_name = "w03-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module w04-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.105"
  vm_name = "w04-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module w05-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.106"
  vm_name = "w05-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module w06-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.107"
  vm_name = "w06-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module w07-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.108"
  vm_name = "w07-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module w08-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.109"
  vm_name = "w08-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module w09-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.110"
  vm_name = "w09-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module w10-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.111"
  vm_name = "w10-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 100,
      number = 3     
    }
  ]
  }
 
module w11-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.114"
  vm_name = "w11-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 200,
      number = 3     
    }
  ]
  }
 
module w12-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.115"
  vm_name = "w12-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 200,
      number = 3     
    }
  ]
  }
 
module w13-apps-nonprod-blue {
  source = "git@git.homecredit.net:country/vn/devops/terraform/vsphere_vm.git?ref=v_0.2"
  vm_ip = "10.19.168.116"
  vm_name = "w13-apps-nonprod-blue"
  vsphere_vm_template_name = var.vsphere_vm_template_name
  dns_servers_list = var.dns_servers_list
  vsphere_datacenter_name = var.vsphere_datacenter_name_pdc
  vsphere_datastore_name = var.vsphere_datastore_name_pdc
  vsphere_cluster_name = var.vsphere_cluster_name_pdc
  vsphere_network_name = var.vsphere_network_pdc["name"]
  default_gw = var.vsphere_network_pdc["default_gw"]
    
  vm_cpu_count = 16
  
  vm_memory_size = 36864
  
  additional_disks = [
    { 
      size   = 200,
      number = 3     
    }
  ]
  }
