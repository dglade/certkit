import os
import subprocess


def input_yes_no(query):
    answer = ''
    while answer.lower() not in ['yes', 'y', 'no', 'n']:
        answer = raw_input('%s (y/n): ' % query)
    return answer[0] == 'y'


if __name__ == '__main__':

    script = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'root_cert.sh')

    gen_private = input_yes_no('Generate a new private key/cert?')
    gen_intermediate = input_yes_no('Generate a new intermediate key/cert?')
    gen_server_cert = input_yes_no('Generate a new server key/cert?')
    gen_client_cert = input_yes_no('Generate a new client key/cert?')

    subprocess.call(
        [
            script,
            str(gen_private),
            str(gen_intermediate),
            str(gen_server_cert),
            str(gen_client_cert)
        ]
    )
