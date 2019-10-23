#!/bin/bash
#
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This shell is used to auto generate some useful tools for k8s, such as lister,
# informer, deepcopy, defaulter and so on.

set -o errexit
set -o nounset
set -o pipefail

CODEGEN_PKG=/Users/czx/github/kubernetes/code-generator

${CODEGEN_PKG}/generate-groups.sh "client,informer,lister" \
  github.com/kubeflow/pipelines/backend/src/crd/pkg/client1 \
  github.com/kubeflow/pipelines/backend/src/crd/pkg/apis \
  clockedpipeline:v1beta1 \
  --go-header-file /Users/czx/github/kubeflow/pipelines/backend/src/crd/hack/custom-boilerplate.go.txt
