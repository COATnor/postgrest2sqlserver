FROM mcr.microsoft.com/mssql-tools

RUN apt-get update && apt-get install -qy --no-install-recommends miller
COPY --chmod=+x move_data.sh /usr/local/bin/move_data.sh

ENV DELETE=false

ENTRYPOINT ["move_data.sh"]
CMD "false"
