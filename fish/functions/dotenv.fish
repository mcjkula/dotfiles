function dotenv --description "Load environment variables from .env file"
    set -l env_file ".env"
    if set -q argv[1]
        set env_file $argv[1]
    end

    if not test -f $env_file
        echo "Error: File '$env_file' not found" >&2
        return 1
    end

    for line in (cat $env_file | grep -v '^#' | grep -v '^\s*$')
        set -l kv (string split -n -m 1 = $line)
        
        if test (count $kv) -ne 2
            continue
        end

        set -l key (string trim $kv[1])
        set -l value (string trim $kv[2])
        
        set value (string trim -c '"' $value)
        set value (string trim -c "'" $value)
        
        set -gx $key $value
    end
    return 0
end
