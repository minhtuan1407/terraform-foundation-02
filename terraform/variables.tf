variable "vsphere_user_pdc" {
  description = "vsphere server for the pdc environment - EXAMPLE: vsphereuser"
}

variable "vsphere_password_pdc" {
  description = "vsphere server password for the pdc environment"
}

variable "vsphere_user_drc" {
  description = "vsphere server for the pdc environment - EXAMPLE: vsphereuser"
  
}

variable "vsphere_password_drc" {
  description = "vsphere server password for the pdc environment"
}

# PDC
variable "vsphere_server_pdc" {
  description = "vsphere server for the environment - EXAMPLE: vcenter01.hosted.local"
  default     = "vnpdcvct02.pdc.hcnet.vn"
}

variable "vsphere_datacenter_name_pdc" {
  description = "Vsphere DC name"
  default     = "PDC_Viettel"
}

variable "vsphere_datastore_name_pdc" {
  description = "Vsphere Data Storage name PDC"
  default     = "LAN_Linux_04"
}

variable "vsphere_cluster_name_pdc" {
  description = "Vsphere Cluster name PDC"
  default     = "LAN_LinuxServers"
}

variable "vsphere_network_pdc" {
  type    = map
  description = "Vsphere network in PDC"
  default     = {
    name = "NONPROD_APP_676" 
    default_gw = "10.19.168.254"
  }
}

# DRC
variable "vsphere_server_drc" {
  description = "vsphere server for the environment - EXAMPLE: vcenter01.hosted.local"
  default     = "10.17.173.10"
}

variable "vsphere_datacenter_name_drc" {
  description = "Vsphere DC name"
  default     = "??"
}


variable "vsphere_cluster_name_drc" {
  description = "Vsphere Cluster name PDC"
  default     = "LAN_LinuxServers"
}

variable "vsphere_datastore_name_drc" {
  description = "Vsphere Data Storage name PDC"
  default     = "LAN_Linux_04"
}

variable "vsphere_network_drc" {
  type    = map
  description = "Vsphere network in DRC"
  default     = {
    name = "NONPROD_APP_676" 
    default_gw = "10.19.168.254"
  }
}

# VM template
variable "vsphere_vm_template_name" {
  description = "Vsphere VM template name"
  default     = "ol7_dynamic_disk"
}

# sizing
variable "vm_cpu_count" {
  description = "VM number of vCPU"
  default     = "2"
}

variable "vm_memory_size" {
  description = "VM memory size in MB"
  default     = "4096"
}

variable "vm_cpu_count_master" {
  description = "VM number of vCPU"
  default     = "4"
}

variable "vm_memory_size_master" {
  description = "VM memory size in MB"
  default     = "8192"
}

# other settings
variable "dns_domain" {
  description = "Defautl DNS domain zone"
  default     = "hcnet.vn"
}

variable "resolvers_dns_domain" {
  description = "Defautl DNS domain zone"
  default     = ["hcnet.vn"]
}

variable "dns_servers_list" {
  type    = list(string)
  description = "DNS servers"
  default     = ["10.19.173.5", "10.19.173.6"]
}
