# Copyright (c) 2021 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  unique_prefix = length(var.unique_prefix) > 0 ? var.unique_prefix : "lz"
  top_compartment_parent_id = length(var.existing_enclosing_compartments_parent_ocid) > 0 ? var.existing_enclosing_compartments_parent_ocid : var.tenancy_ocid
  # Whether compartments should be deleted in terraform destroy or upon resource removal.
  enable_cmp_delete = false
  enclosing_compartments     = length(var.enclosing_compartment_names) > 0 ? {for c in var.enclosing_compartment_names : c => {parent_id: local.top_compartment_parent_id, name: length(var.unique_prefix) > 0 ? "${var.unique_prefix}-${c}" : c, description: "Landing Zone enclosing compartment", enable_delete: local.enable_cmp_delete, defined_tags: null, freeform_tags: null}} : {"${local.unique_prefix}-top-cmp" : {parent_id: local.top_compartment_parent_id, name: "${local.unique_prefix}-top-cmp", description: "Landing Zone enclosing compartment", enable_delete: local.enable_cmp_delete, defined_tags: null, freeform_tags: null}}
  provisioning_group_names   = var.use_existing_provisioning_group == false ? {for k in keys(local.enclosing_compartments) : k => {group_name: "${k}-provisioning-group"}} : {(local.unique_prefix) : {group_name : var.existing_provisioning_group_name}}
  
  lz_group_names             = var.use_existing_groups == false ? {for k in keys(local.enclosing_compartments) : k => {group_name_prefix:"${k}-"}} : {(local.unique_prefix) : {group_name_prefix: ""}}

  iam_admin_group_name_suffix           = var.use_existing_groups == false ? "iam-admin-group" : data.oci_identity_groups.existing_iam_admin_group.groups[0].name
  cred_admin_group_name_suffix          = var.use_existing_groups == false ? "cred-admin-group" : data.oci_identity_groups.existing_cred_admin_group.groups[0].name
  network_admin_group_name_suffix       = var.use_existing_groups == false ? "network-admin-group" : data.oci_identity_groups.existing_network_admin_group.groups[0].name
  security_admin_group_name_suffix      = var.use_existing_groups == false ? "security-admin-group" : data.oci_identity_groups.existing_security_admin_group.groups[0].name
  appdev_admin_group_name_suffix        = var.use_existing_groups == false ? "appdev-admin-group" : data.oci_identity_groups.existing_appdev_admin_group.groups[0].name
  database_admin_group_name_suffix      = var.use_existing_groups == false ? "database-admin-group" : data.oci_identity_groups.existing_database_admin_group.groups[0].name
  auditor_group_name_suffix             = var.use_existing_groups == false ? "auditor-group" : data.oci_identity_groups.existing_auditor_group.groups[0].name
  announcement_reader_group_name_suffix = var.use_existing_groups == false ? "announcement-reader-group" : data.oci_identity_groups.existing_announcement_reader_group.groups[0].name
  exainfra_admin_group_name_suffix      = var.use_existing_groups == false ? "exainfra-admin-group" : data.oci_identity_groups.existing_exainfra_admin_group.groups[0].name
  cost_admin_group_name_suffix          = var.use_existing_groups == false ? "cost-admin-group" : data.oci_identity_groups.existing_cost_admin_group.groups[0].name
  
  grant_tenancy_level_mgmt_policies = true
}