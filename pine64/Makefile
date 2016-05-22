
all: .kernel.checkout

.kernel.checkout:
	if [ -d linux-pine64 ] ; then \
		git clone https://github.com/longsleep/linux-pine64 ; \
	    (cd linux-pine64 ; git checkout pine64-hacks-1.2) ; \
	fi
	touch .kernel.checkout
