VM[1]=8e410780-a26a-4f8d-b126-137a56158675
VM[2]=3fb6ce3e-fabd-4bff-877a-36d2cdd39c4c
VM[3]=5389674f-c1c6-4c88-b990-c96c61c262a2
VM[4]=7688d758-3cdb-482d-9f32-2a43f90cacd8
VM[5]=80fe018f-6c86-42c3-b042-832745edc899

for (( i=1; i<=5; i++ ))
do
    curl -H "Content-Type: application/json" -H "X-Auth-Token:gAAAAABaH9pdWIUzxEWB9pUX206QGNGy0UtnCPJvFNYm0roq5XMMAjy4aosgFGbL-eW--QK6pcuP1SiCMjKSPM-ODlxjt84VRo049w-EuCLhlTjCnGYUnACx5rWtFNXibomuoSEdKkKmsEgeG-K779eOCQ4O9gfTHmkGmxSD4ffzrA6UYLbl2LA" -X POST -d '{"evacuate": {"host": "compute1","onSharedStorage": true}}' 'http://127.0.0.1:8774/v2.1/ba2edeaeffb240709dcaaf8bb75a1d74/servers/'${VM[$i]}'/action'
done
