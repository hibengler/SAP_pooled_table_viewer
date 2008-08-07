

B=/build/0

BUILDSET= \
step1.sql \
step2.sql \
step3.sql \
step1_sapsr3.sql \
step2_sapsr3.sql \
step3_sapsr3.sql \
readme.txt

system: $(BUILDSET)
	cp $? $(B)


