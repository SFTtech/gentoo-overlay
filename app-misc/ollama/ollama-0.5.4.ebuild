# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


if [[ ${PV} == *9999 ]]; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ollama/ollama.git"
fi

ROCM_VERSION=6.1
inherit go-module rocm ${SCM}

DESCRIPTION="Infer on language models like Llama, Phi, Mistral, Gemma."
HOMEPAGE="https://ollama.com"
LICENSE="MIT"
SLOT="0"
RESTRICT="network-sandbox"

IUSE="cuda rocm video_cards_amdgpu cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_avx512"
RDEPEND=""
IDEPEND="${RDEPEND}"
BDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit )
	rocm? (
		sci-libs/hipBLAS:0/${ROCM_VERSION}
		dev-libs/rocm-opencl-runtime
	)
"

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/ollama/ollama/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		default
	fi
}

src_compile() {

	cpufeatures=()
	use cpu_flags_x86_avx && cpufeatures+=("avx")
	use cpu_flags_x86_avx2 && cpufeatures+=("avx2")
	use cpu_flags_x86_avx512 && cpufeatures+=("avx512" "avx512vbmi" "avx512vnni" "avx512bf16")

	export CUSTOM_CPU_FLAGS=$(IFS=, ; echo "${cpufeatures[*]}")

	if use video_cards_amdgpu && use rocm; then
		export HIP_ARCHS=$(get_amdgpu_flags)
		export HIP_PATH="/usr"
	else
		export OLLAMA_SKIP_ROCM_GENERATE=1
	fi

	if ! use cuda; then
		export OLLAMA_SKIP_CUDA_GENERATE=1
	fi

	export GOFLAGS=-v
	emake dist
}

src_install() {
	dobin dist/linux-${ARCH}/bin/ollama
}

pkg_postinst() {
	einfo "run with: ollama serve"
	einfo "See available models at https://ollama.com/library"
}
