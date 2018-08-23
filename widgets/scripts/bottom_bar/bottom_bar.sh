cd ./scripts/bottom_bar && \
echo "$(sh ./cpu_script)@$(sh ./mem_script)@$(sh ./networktraffic)@$(sh ./hd_script)@$(sh ./kubernetes_context)" && \
cd ../..
