import sys
import re
import os

# --- Funções Auxiliares para Formatação ---

def get_digits(n):
    """Retorna o número de dígitos em um inteiro."""
    if n == 0:
        return 1
    count = 0
    temp = n
    while temp > 0:
        temp //= 10
        count += 1
    return count

def format_data_line(addr, data):
    """Formata uma linha de dados individual com espaçamento corrigido."""
    # Calcula o espaçamento igual ao seu código C (5 - num_digitos)
    spacing = 5 - get_digits(addr)
    if spacing < 1:
        spacing = 1
    spaces = " " * spacing
    
    # Recria a linha de dados com a numeração e espaçamento corretos
    # Nota: O seu exemplo "certo" parece ter espaços extras ao redor do ":"
    return f"\t{addr}{spaces}: {data};\n"

# --- Regex para Parsear o Arquivo ---

# Captura ranges: ex [0..255] : 00000000;
# Grupo 1: início (0), Grupo 2: fim (255), Grupo 3: dados (00000000)
range_re = re.compile(r"^\s*\[(\d+)\.\.(\d+)\]\s*:\s*([01]+)\s*;")

# Captura linhas únicas: ex 0 : 00000000;
# Grupo 1: endereço (0), Grupo 2: dados (00000000)
single_line_re = re.compile(r"^\s*(\d+)\s*:\s*([01]+)\s*;")

# Captura linhas de cabeçalho que queremos manter
header_re = re.compile(r"^(WIDTH|DEPTH|ADDRESS_RADIX|DATA_RADIX|CONTENT BEGIN)")

# Captura o fim do arquivo
end_re = re.compile(r"^END;")


def expand_and_renumber(input_path, output_path):
    """
    Expande um charmap .mif com 'ranges' para um formato
    linha-por-linha, renumerando tudo sequencialmente.
    """
    
    header_lines = []
    all_data_values = []
    end_line = None

    print(f"Lendo e 'expandindo' {input_path}...")

    try:
        # --- FASE 1: Ler o arquivo de entrada e coletar todos os dados ---
        with open(input_path, 'r') as f_in:
            for line in f_in:
                # Tenta dar match com os padrões
                range_match = range_re.search(line)
                single_match = single_line_re.search(line)
                header_match = header_re.search(line)
                end_match = end_re.search(line)

                if header_match or (line.strip() == "" and not all_data_values):
                    # Salva o cabeçalho e linhas em branco no início
                    header_lines.append(line)
                
                elif range_match:
                    # É um RANGE. Vamos expandi-lo.
                    start = int(range_match.group(1))
                    end = int(range_match.group(2))
                    data = range_match.group(3)
                    
                    # Adiciona 'data' à nossa lista (end - start + 1) vezes
                    count = (end - start) + 1
                    for _ in range(count):
                        all_data_values.append(data)
                
                elif single_match:
                    # É uma linha de dado única.
                    data = single_match.group(2)
                    all_data_values.append(data)

                elif end_match:
                    # Guarda a linha final
                    end_line = line
                
                # Outras linhas (como "-- !" ou comentários) são ignoradas

        print(f"Encontrados {len(all_data_values)} endereços de dados no total.")

        # --- FASE 2: Escrever o novo arquivo de saída formatado ---
        print(f"Escrevendo o novo arquivo {output_path}...")
        with open(output_path, 'w') as f_out:
            # Escreve o cabeçalho
            for line in header_lines:
                f_out.write(line)
            
            current_title_index = 0
            
            # Itera por TODOS os dados que coletamos
            for addr, data in enumerate(all_data_values):
                
                # A CADA 8 LINHAS (addr % 8 == 0), imprime um novo título
                if addr % 8 == 0:
                    # Adiciona uma linha em branco antes do novo título
                    if addr > 0:
                        f_out.write("\n") 
                    
                    f_out.write(f"-- [{current_title_index}]\n")
                    current_title_index += 1
                
                # Escreve a linha de dados formatada
                f_out.write(format_data_line(addr, data))
            
            # Escreve a linha "END;" no final
            if end_line:
                # Adiciona uma quebra de linha antes do END;
                f_out.write("\n") 
                f_out.write(end_line)
                
    except FileNotFoundError:
        print(f"Erro: Arquivo de entrada não encontrado '{input_path}'")
        sys.exit(1)
    except Exception as e:
        print(f"Ocorreu um erro: {e}")
        sys.exit(1)

# --- Bloco de Execução Principal ---
if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Uso: python {os.path.basename(sys.argv[0])} <arquivo_entrada.mif> <arquivo_saida.mif>")
        print("Exemplo: python expandir.py charmap_com_ranges.mif charmap_expandido.mif")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    expand_and_renumber(input_file, output_file)
    print("Conversão concluída com sucesso!")