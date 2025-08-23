# Criar diretorio de rede compartilhado

## Configuração no host (192.168.1.111)
1. Instalar o servidor NFS:
    > sudo apt update

    > sudo apt install nfs-kernel-server -y

2. Editar o arquivo de exports:
    > sudo nano /etc/exports

    > /media/rprojetos/rprojetos   192.168.1.0/24(rw,sync,no_subtree_check)

    ctrl + o .. enter .. ctrl + x .. enter

3. Aplica as permissões:
    > sudo exportfs -a

4. Reiniciar o serviço:
    > sudo systemctl restart nfs-kernel-server

## Configuração no cliente (192.168.1.109)
1. Instalar o cliente NFS:
> sudo apt install nfs-common -y

2. Criar um ponto de montagem local (exemplo):
> sudo mkdir -p /media/ricardo/rprojetos

3. Adiciona no final do arquivo /etc/fstab:
    192.168.1.111:/media/rprojetos/rprojetos   /media/ricardo/rprojetos   nfs   defaults   0   0

4. Teste de montagem, sem ter que reiniciar:
> sudo mount -a

