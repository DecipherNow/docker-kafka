#   Copyright 2019 Decipher Technology Studios
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

IMAGE := deciphernow/kafka
VERSION := $(shell cat VERSION)

.PHONY: build
build:
	@docker build -t "$(IMAGE):latest" -t "$(IMAGE):$(VERSION)" --build-arg "VERSION=$(VERSION)" .

.PHONY: publish
publish: build
	@docker push "$(IMAGE):latest"
	@docker push "$(IMAGE):$(VERSION)"