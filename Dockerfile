FROM mcr.microsoft.com/mssql-tools

COPY --chmod=+x move_data.sh /usr/local/bin/move_data.sh

ENV DELETE=false

ENTRYPOINT ["move_data.sh"]
CMD "false"
